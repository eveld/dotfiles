# Personal Dotfiles

## Setup

```bash
curl -sSL https://raw.githubusercontent.com/eveld/dotfiles/main/setup.sh | sh
```

## What it installs

- Zsh + Oh My Zsh (agnoster theme)
- Neovim + LazyVim 
- Go (latest stable) + gopls + delve
- Dev tools: bottom, direnv, fd, fzf, lazygit, mosh, ripgrep, zellij
- 1Password CLI
- Git config, SSH config for 1Password agent

## Managing dotfiles

```bash
# Edit a file
chezmoi edit ~/.zshrc

# Apply changes  
chezmoi apply

# Add new dotfile
chezmoi add ~/.newconfig

# Update from repo
chezmoi update
```

## How it works

- `setup.sh` installs chezmoi and runs `chezmoi init --apply`
- chezmoi runs the `run_once_*` scripts in order:
  1. Bootstrap (installs basic packages per OS)
  2. Shell (sets up zsh, installs Oh My Zsh with `--keep-zshrc`)
  3. Packages (installs dev tools, Go via shared `install_go.sh`)  
  4. Configure (git config, SSH config)

## Testing

```bash
# Ubuntu
docker build -f Dockerfile.ubuntu -t test-ubuntu . 
echo "y" | docker run -i test-ubuntu /tmp/setup.sh

# Arch
docker build -f Dockerfile.test -t test-arch .
echo "y" | docker run -i test-arch /tmp/setup.sh
```

## Notes

- Works on macOS, Arch, Ubuntu 24.04+
- Go installation is standardized across all platforms (latest stable from golang.org)
- All package scripts use shared `install_go.sh` for consistency
- Oh My Zsh uses `--keep-zshrc` so it doesn't overwrite the chezmoi-managed `.zshrc`