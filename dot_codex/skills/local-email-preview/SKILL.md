---
name: local-email-preview
description: Preview and verify application emails locally with Mailpit. Use when a user asks to test email delivery, inspect rendered email content, start a local email inbox, or resend a local preview.
---

# Local Email Preview

Use Mailpit as a local inbox and distinguish integration evidence from visual-only evidence.

## Workflow

1. Inspect the project's existing email backend, local services, and documented commands. Reuse a running Mailpit and the project's real send path when available.
2. Ensure Mailpit is reachable. The helper reuses the configured UI port, starts its existing container when stopped, or creates one without deleting containers or messages:

   ```bash
   python3 <skill-dir>/scripts/mailpit.py ensure
   ```

3. Prefer **integration mode**: configure the application to use Mailpit SMTP, then trigger the actual application code path. This is the only mode that validates application arguments, i18n, templates, and backend integration.
4. When the application environment is blocked, use **preview mode** to inspect content and layout:

   ```bash
   python3 <skill-dir>/scripts/mailpit.py send \
     --subject "Preview subject" \
     --to "preview@example.test" \
     --body "Preview body"
   ```

   For multiline or generated content, pass `--body-file <path>` instead of shell-escaping the body. Preview mode sends directly over local SMTP and does not validate the application code path.
5. Read the message back from Mailpit before reporting success:

   ```bash
   python3 <skill-dir>/scripts/mailpit.py latest
   ```

## Completion

Report the clickable Mailpit URL, subject, recipients, and whether the run used integration or preview mode. State any application tests that were blocked. A successful SMTP command without Mailpit readback is incomplete.

## Configuration

Defaults are `127.0.0.1:1025` for SMTP and `http://127.0.0.1:8025` for the UI. Override them with the helper's `--smtp-host`, `--smtp-port`, `--ui-host`, and `--ui-port` options. Use `--help` for container name and image overrides.
