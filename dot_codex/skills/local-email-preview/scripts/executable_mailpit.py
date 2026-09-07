#!/usr/bin/env python3
"""Start Mailpit, send a local preview, and verify it through the Mailpit API."""

from __future__ import annotations

import argparse
import html
import json
import smtplib
import subprocess
import sys
import time
import urllib.error
import urllib.request
from email.message import EmailMessage
from email.utils import make_msgid
from pathlib import Path
from typing import Any


def api_url(args: argparse.Namespace, path: str) -> str:
    return f"http://{args.ui_host}:{args.ui_port}{path}"


def fetch_json(url: str) -> dict[str, Any]:
    with urllib.request.urlopen(url, timeout=2) as response:
        return json.load(response)


def mailpit_ready(args: argparse.Namespace) -> bool:
    try:
        fetch_json(api_url(args, "/api/v1/messages?limit=1"))
    except (OSError, urllib.error.URLError, json.JSONDecodeError):
        return False
    return True


def docker(*command: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["docker", *command],
        check=check,
        capture_output=True,
        text=True,
    )


def ensure(args: argparse.Namespace) -> None:
    if mailpit_ready(args):
        print(json.dumps({"status": "ready", "ui_url": api_url(args, "")}, ensure_ascii=False))
        return

    existing = docker("container", "inspect", args.container_name, check=False)
    if existing.returncode == 0:
        docker("start", args.container_name)
    else:
        docker(
            "run",
            "-d",
            "--name",
            args.container_name,
            "-p",
            f"127.0.0.1:{args.smtp_port}:1025",
            "-p",
            f"127.0.0.1:{args.ui_port}:8025",
            args.image,
        )

    for _ in range(30):
        if mailpit_ready(args):
            print(json.dumps({"status": "ready", "ui_url": api_url(args, "")}, ensure_ascii=False))
            return
        time.sleep(0.5)
    raise RuntimeError(f"Mailpit did not become ready at {api_url(args, '')}")


def message_summary(args: argparse.Namespace, message: dict[str, Any]) -> dict[str, Any]:
    message_id = message["ID"]
    return {
        "id": message_id,
        "subject": message.get("Subject", ""),
        "from": message.get("From", {}).get("Address", ""),
        "to": [recipient.get("Address", "") for recipient in message.get("To") or []],
        "created": message.get("Created", ""),
        "view_url": api_url(args, f"/view/{message_id}"),
    }


def messages(args: argparse.Namespace) -> list[dict[str, Any]]:
    payload = fetch_json(api_url(args, "/api/v1/messages?limit=50"))
    return payload.get("messages", [])


def latest(args: argparse.Namespace) -> None:
    inbox = messages(args)
    if not inbox:
        raise RuntimeError("Mailpit inbox is empty")
    print(json.dumps(message_summary(args, inbox[0]), ensure_ascii=False, indent=2))


def load_body(args: argparse.Namespace) -> str:
    if args.body_file:
        if args.body_file == "-":
            return sys.stdin.read()
        return Path(args.body_file).read_text(encoding="utf-8")
    if args.body is not None:
        return args.body
    raise ValueError("Provide --body or --body-file")


def send(args: argparse.Namespace) -> None:
    body = load_body(args)
    message = EmailMessage()
    message_id = make_msgid(domain="local-email-preview")
    message["Message-ID"] = message_id
    message["Subject"] = args.subject
    message["From"] = args.from_address
    message["To"] = args.to
    message.set_content(body)
    message.add_alternative(f"<p>{html.escape(body).replace(chr(10), '<br>')}</p>", subtype="html")

    with smtplib.SMTP(args.smtp_host, args.smtp_port, timeout=5) as smtp:
        smtp.send_message(message)

    expected = message_id.strip("<>")
    for _ in range(20):
        for received in messages(args):
            if received.get("MessageID") == expected:
                print(json.dumps(message_summary(args, received), ensure_ascii=False, indent=2))
                return
        time.sleep(0.25)
    raise RuntimeError("SMTP accepted the message, but Mailpit API readback did not find it")


def parser() -> argparse.ArgumentParser:
    root = argparse.ArgumentParser(description=__doc__)
    root.add_argument("--smtp-host", default="127.0.0.1")
    root.add_argument("--smtp-port", type=int, default=1025)
    root.add_argument("--ui-host", default="127.0.0.1")
    root.add_argument("--ui-port", type=int, default=8025)
    commands = root.add_subparsers(dest="command", required=True)

    ensure_parser = commands.add_parser("ensure", help="Reuse or start a Mailpit container")
    ensure_parser.add_argument("--container-name", default="codex-mailpit")
    ensure_parser.add_argument("--image", default="axllent/mailpit:latest")
    ensure_parser.set_defaults(run=ensure)

    latest_parser = commands.add_parser("latest", help="Read back the latest Mailpit message")
    latest_parser.set_defaults(run=latest)

    send_parser = commands.add_parser("send", help="Send and verify a visual-only SMTP preview")
    send_parser.add_argument("--subject", required=True)
    send_parser.add_argument("--to", required=True)
    send_parser.add_argument("--from-address", default="no-reply@local.preview")
    body_group = send_parser.add_mutually_exclusive_group(required=True)
    body_group.add_argument("--body")
    body_group.add_argument("--body-file")
    send_parser.set_defaults(run=send)
    return root


def main() -> int:
    args = parser().parse_args()
    try:
        args.run(args)
    except (OSError, RuntimeError, ValueError, subprocess.CalledProcessError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
