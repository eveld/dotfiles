#!/bin/sh
set -eu

# Install development packages for Debian/Ubuntu
echo "Installing Debian/Ubuntu packages..."

echo "Installing packages via apt..."
sudo apt update
sudo apt install -y \
    build-essential \
    direnv \
    fd-find \
    fzf \
    golang \
    mosh \
    neovim \
    ripgrep \
    tmux

# Install tools not in default repos
echo "Installing additional tools..."

# Install bottom
if ! command -v btm >/dev/null 2>&1; then
    echo "Installing bottom..."
    curl -LO https://github.com/ClementTsang/bottom/releases/latest/download/bottom_x86_64-unknown-linux-musl.tar.gz
    tar -xzf bottom_x86_64-unknown-linux-musl.tar.gz
    sudo mv btm /usr/local/bin/
    rm bottom_x86_64-unknown-linux-musl.tar.gz
fi

# Install lazygit
if ! command -v lazygit >/dev/null 2>&1; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
fi

# Install zellij
if ! command -v zellij >/dev/null 2>&1; then
    echo "Installing zellij..."
    curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar -xz -C /tmp
    sudo mv /tmp/zellij /usr/local/bin/
fi

# Install Go tools
if command -v go >/dev/null 2>&1; then
    echo "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
fi

echo "Debian/Ubuntu package installation complete"