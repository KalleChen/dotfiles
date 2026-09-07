## Setup

Install homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install chezmoi

```bash
/opt/homebrew/bin/brew install chezmoi
```

Init chezmoi

```bash
/opt/homebrew/bin/chezmoi init https://github.com/KalleChen/dotfiles.git
/opt/homebrew/bin/chezmoi apply
source ~/.zshrc
```

Install brew apps

```bash
brew bundle --file=~/.config/Brewfile
```

Install nvm
https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating

Install tpm
```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Update chezmoi

```bash
dot update
```

dump homebrew

```bash
brew bundle dump --file=~/.config/Brewfile
```


## Codex configuration sync

`dot` is an alias for `chezmoi`. This repo manages Codex instructions, custom
agents, selected personal skills, and shared settings in `~/.codex/config.toml`.

### How the config template works

- `dot_codex/modify_private_config.toml` merges managed values into the existing
  config using chezmoi's native `modify-template` support. No separate
  `config.local.toml` or extra runtime dependency is needed for applying it.
- Shared values include model/reasoning settings, permission preferences,
  selected MCP servers, plugin/tool settings, UI preferences, and Git marketplace
  sources. The template is the source of truth for these fields.
- Project trust, credentials, hook hashes, App-managed Node/browser runtime
  configuration, and other unmanaged fields remain local.
- Home paths adapt to the destination user. Apple Reminders, Apple Notes plugin
  settings, and desktop preferences are macOS-only. Syncing configuration does
  not install plugins, MCP binaries, or credentials; Apple Reminders currently
  references Node v24.13.1 and MCP server v1.4.0 under the user's home directory.
- If values are unchanged, the original file is preserved. If values change,
  TOML is reserialized: formatting and comments may change, but unmanaged values
  are retained. Existing file permissions remain private.

### Pull and apply on another machine

To review incoming changes before applying them:

```bash
chezmoi update --apply=false
chezmoi diff ~/.codex/config.toml
chezmoi apply ~/.codex/config.toml
chezmoi verify ~/.codex/config.toml
```

This applies only the Codex config. To preview and apply all managed files,
use `chezmoi diff` followed by `chezmoi apply` instead.
`chezmoi update` (or `dot update`) is the shortcut that pulls and immediately
applies all managed files. Resolve any local source-repo changes before pulling.

### Change shared config values and publish them

Edit the source template directly, rather than running `chezmoi add` on the live
config. Changes made only in the Codex App to managed fields are reset on the
next apply. Unmanaged local changes are preserved.

```bash
cd "$(chezmoi source-path)"
# Edit dot_codex/modify_private_config.toml in your editor.
chezmoi diff ~/.codex/config.toml
chezmoi apply ~/.codex/config.toml
chezmoi verify ~/.codex/config.toml
git diff --check
git diff -- dot_codex/modify_private_config.toml
git add dot_codex/modify_private_config.toml
git commit -m "chore: update shared Codex settings"
git push
```

When adding a new field, set its individual key path so neighboring local values
survive. Do not copy credentials, runtime paths, or trust hashes into the template.
Removing a template assignment stops managing that field; it does not delete the
existing value from each machine.

For ordinary managed files such as `AGENTS.md`, agent TOML files, and skills,
record local edits with `chezmoi add <path>`, review the source-repo diff, then
commit and push the intended files.

### Verify the merge behavior

Applying the template requires chezmoi. The optional regression check also needs
Python 3.11+ (`tomllib`) and an existing local Codex config already matching the
template:

```bash
cd "$(chezmoi source-path)"
python3 .chezmoitemplates/codex-config/test_config_sync.py \
  dot_codex/modify_private_config.toml
```

The script checks unchanged live config, empty initialization, preservation of
local fields, idempotency, invalid TOML, and alternate home/OS rendering. It is
stored in the source repo; `.chezmoitemplates/` is not copied into the home
directory by `chezmoi apply`. If intentionally changing the baseline model,
update the test's expected model too. `chezmoi verify` remains the lightweight
check that the current machine matches the template.
