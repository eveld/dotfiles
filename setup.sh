#!/bin/sh
set -eu

# Minimal bootstrap script - installs prerequisites, chezmoi, and initializes dotfiles
# Everything else is handled by chezmoi run_once scripts

VERSION="2.4.1"
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

# Ensure we have the absolute minimum requirements: git and curl/wget
echo "Checking prerequisites..."
if ! command -v git >/dev/null 2>&1; then
    echo "Installing git..."
    case "$(uname)" in
        Darwin)
            if command -v brew >/dev/null 2>&1; then
                brew install git curl
            else
                echo "Error: Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            ;;
        Linux)
            if command -v apt >/dev/null 2>&1; then
                sudo apt update && sudo apt install -y git curl
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -Sy --noconfirm git curl
            else
                echo "Error: Unable to install git. Please install git and curl manually."
                exit 1
            fi
            ;;
        *)
            echo "Error: Unsupported OS"
            exit 1
            ;;
    esac
fi

# Install chezmoi if not already installed
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "Installing chezmoi..."
    curl -fsLS get.chezmoi.io | sh
    
    # Add to PATH for this session
    export PATH="$HOME/bin:$PATH"
fi

# Initialize and apply dotfiles (this runs all run_once scripts)
echo "Initializing dotfiles from $DOTFILES_REPO..."
chezmoi init --apply "$DOTFILES_REPO"

echo
echo "Setup complete! Your development environment is ready."
echo "Run 'exec zsh' to start using your configured shell"