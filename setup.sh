#!/bin/sh
set -eu

# Bootstrap script for setting up a fresh machine
# Supports Ubuntu/Debian, Arch Linux, and macOS

VERSION="1.0.0"

# Detect operating system
detect_os() {
    case "$(uname)" in
        "Darwin")
            OS="macos"
            echo "Detected macOS"
            ;;
        "Linux")
            if command -v apt >/dev/null 2>&1; then
                OS="debian" 
                echo "Detected Debian/Ubuntu"
            elif command -v pacman >/dev/null 2>&1; then
                OS="arch"
                echo "Detected Arch Linux"
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

# Install basic packages needed for setup
install_basics() {
    echo "Installing basic packages..."
    
    case "$OS" in
        "macos")
            if ! command -v brew >/dev/null 2>&1; then
                echo "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            brew install git curl zsh
            ;;
        "debian")
            sudo apt update
            sudo apt install -y git curl wget ca-certificates gnupg lsb-release zsh
            ;;
        "arch")
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm git curl wget unzip zsh
            ;;
    esac
}

# Install 1Password CLI
install_1password_cli() {
    echo "Installing 1Password CLI..."
    
    case "$OS" in
        "macos")
            brew install 1password-cli
            ;;
        "debian")
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
                sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
                sudo tee /etc/apt/sources.list.d/1password.list
            
            sudo apt update && sudo apt install -y 1password-cli
            ;;
        "arch")
            # Install 1Password CLI manually for Arch
            OP_URL=$(curl -s https://app-updates.agilebits.com/product_history/CLI2 | grep -o 'https://[^"]*linux_amd64[^"]*\.zip' | head -1)
            curl -sSO "$OP_URL"
            unzip -q op_linux_amd64_*.zip
            sudo mv op /usr/local/bin/
            rm -f op_linux_amd64_*.zip
            ;;
    esac
}

# Install chezmoi
install_chezmoi() {
    echo "Installing chezmoi..."
    if ! command -v chezmoi >/dev/null 2>&1; then
        curl -fsLS get.chezmoi.io | sudo sh -s -- -b /usr/local/bin
    fi
}

# Setup zsh as default shell
setup_shell() {
    echo "Setting up zsh as default shell..."
    if command -v zsh >/dev/null 2>&1; then
        ZSH_PATH=$(command -v zsh)
        CURRENT_SHELL=$(getent passwd "$(whoami)" | cut -d: -f7)
        if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
            echo "Changing default shell to zsh..."
            sudo chsh -s "$ZSH_PATH" "$(whoami)"
            echo "Shell changed to zsh"
        else
            echo "zsh is already the default shell"
        fi
    fi
}

# Setup 1Password CLI authentication
setup_1password() {
    echo "Setting up 1Password CLI..."
    echo "You will need your 1Password Secret Key and Master Password"
    
    # Check if 1Password CLI can access accounts (via desktop app or manual signin)
    if command -v op >/dev/null 2>&1 && op account list >/dev/null 2>&1; then
        echo "1Password CLI is configured"
    else
        echo "1Password CLI needs configuration"
        echo "You can either:"
        echo "1. Enable 1Password desktop app integration"
        echo "2. Run 'op account add' manually later"
        echo "Continuing setup without 1Password authentication..."
    fi
}

# Initialize dotfiles with chezmoi
setup_dotfiles() {
    echo "Setting up dotfiles with chezmoi..."
    
    # Replace with your actual dotfiles repo
    DOTFILES_REPO="https://github.com/eveld/dotfiles.git"
    
    if [ ! -d "$HOME/.local/share/chezmoi" ]; then
        echo "Initializing dotfiles from $DOTFILES_REPO"
        chezmoi init --apply "$DOTFILES_REPO"
    else
        echo "Applying dotfiles updates..."
        chezmoi apply
    fi
}

# Main execution
main() {
    echo "Setup script v$VERSION"
    echo "This will set up your development environment"
    echo "Steps: detect OS, install basics, install 1Password CLI, install chezmoi, authenticate, setup dotfiles"
    echo
    printf "Continue? (y/N) "
    read -r REPLY
    case "$REPLY" in
        [Yy]|[Yy][Ee][Ss])
            ;;
        *)
            echo "Setup cancelled"
            exit 0
            ;;
    esac
    
    detect_os
    install_basics
    setup_shell
    install_1password_cli
    install_chezmoi
    setup_1password
    setup_dotfiles
    
    # Reapply dotfiles to restore our custom configs after Oh My Zsh installation
    echo "Reapplying dotfiles to restore custom configuration..."
    chezmoi apply --force
    
    echo
    echo "Bootstrap complete."
    echo "You can now run 'exec zsh' to start using zsh with your configuration."
}

main "$@"