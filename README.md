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

Update chezmoi

```bash
dot update
```
