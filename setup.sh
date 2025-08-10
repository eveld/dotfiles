#!/bin/sh
set -eu

# Minimal bootstrap script - installs chezmoi and initializes dotfiles
# Everything else is handled by chezmoi run_once scripts

VERSION="2.0.0"
DOTFILES_REPO="https://github.com/eveld/dotfiles.git"

echo "Minimal Bootstrap v$VERSION"
echo "This will install chezmoi and initialize your dotfiles"
echo "All packages and configuration will be handled automatically"
echo
printf "Continue? (y/N) "
read -r REPLY
case "$REPLY" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) echo "Setup cancelled"; exit 0 ;;
esac

# Install chezmoi if not already installed
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "Installing chezmoi..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsLS get.chezmoi.io | sh
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- get.chezmoi.io | sh
    else
        echo "Error: curl or wget required to install chezmoi"
        exit 1
    fi
    
    # Add to PATH for this session
    export PATH="$HOME/bin:$PATH"
fi

# Initialize and apply dotfiles (this runs all run_once scripts)
echo "Initializing dotfiles from $DOTFILES_REPO..."
chezmoi init --apply "$DOTFILES_REPO"

echo
echo "Setup complete! Your development environment is ready."
echo "Run 'exec zsh' to start using your configured shell"