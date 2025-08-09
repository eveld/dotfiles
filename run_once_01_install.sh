#!/bin/sh
set -eu

# Install all development packages and tools
# This runs once when dotfiles are first applied

echo "Installing development packages and tools..."

# Detect OS (same logic as bootstrap)
detect_os() {
    case "$(uname)" in
        "Darwin")
            OS="macos"
            ;;
        "Linux")
            if command -v apt >/dev/null 2>&1; then
                OS="debian" 
            elif command -v pacman >/dev/null 2>&1; then
                OS="arch"
            else
                echo "Error: Unsupported Linux distribution"
                exit 1
            fi
            ;;
        *)
            echo "Error: Unsupported operating system"
            exit 1
            ;;
    esac
}

# Install packages based on OS
install_packages() {
    case "$OS" in
        "macos")
            echo "Installing Xcode Command Line Tools..."
            if ! xcode-select -p >/dev/null 2>&1; then
                xcode-select --install
                echo "Please complete Xcode Command Line Tools installation and re-run this script"
                exit 1
            fi
            
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
            ;;
        "debian")
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
                curl -LO https://github.com/ClementTsang/bottom/releases/latest/download/bottom_x86_64-unknown-linux-musl.tar.gz
                tar -xzf bottom_x86_64-unknown-linux-musl.tar.gz
                sudo mv btm /usr/local/bin/
                rm bottom_x86_64-unknown-linux-musl.tar.gz
            fi
            
            # Install lazygit
            if ! command -v lazygit >/dev/null 2>&1; then
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm lazygit.tar.gz lazygit
            fi
            
            # Install zellij
            if ! command -v zellij >/dev/null 2>&1; then
                curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar -xz -C /tmp
                sudo mv /tmp/zellij /usr/local/bin/
            fi
            ;;
        "arch")
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
            ;;
    esac
}

# Install Go development tools
install_go_tools() {
    if command -v go >/dev/null 2>&1; then
        echo "Installing Go tools..."
        go install golang.org/x/tools/gopls@latest
        go install github.com/go-delve/delve/cmd/dlv@latest
    fi
}

# Oh My Zsh will be installed in the configure script after zsh is available

# Main execution
main() {
    detect_os
    install_packages
    install_go_tools
    
    echo "Package installation complete"
}

main