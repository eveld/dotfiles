#!/bin/sh
set -eu

# Install development packages for macOS
echo "Installing development packages for macOS..."

echo "Installing packages via Homebrew..."
brew install \
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

echo "Package installation complete"