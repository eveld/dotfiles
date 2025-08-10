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
    go \
    lazygit \
    mosh \
    neovim \
    ripgrep \
    tmux \
    zellij

# Install Go tools
if command -v go >/dev/null 2>&1; then
    echo "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
fi

echo "Arch Linux package installation complete"