#!/bin/sh
set -eu

# Install development packages for Arch Linux
echo "Installing Arch Linux packages..."

echo "Installing packages via pacman..."
sudo pacman -S --noconfirm \
    base-devel \
    bottom \
    direnv \
    fd \
    fzf \
    lazygit \
    mosh \
    neovim \
    ripgrep \
    tmux \
    zellij

# Install Go using standardized method
SCRIPTS_DIR="${HOME}/.local/share/chezmoi/scripts"
. "${SCRIPTS_DIR}/install_go.sh"
install_go
install_go_tools

echo "Arch Linux package installation complete"