#!/bin/sh
set -eu

# Install development packages for macOS
echo "Installing macOS packages..."

echo "Installing packages via Homebrew..."
brew install \
    bottom \
    direnv \
    fd \
    fzf \
    lazygit \
    mosh \
    neovim \
    ripgrep \
    zellij

# Install Go using standardized method
SCRIPTS_DIR="${HOME}/.local/share/chezmoi/scripts"
. "${SCRIPTS_DIR}/install_go.sh"
install_go
install_go_tools

echo "macOS package installation complete"