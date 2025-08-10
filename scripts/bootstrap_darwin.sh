#!/bin/sh
set -eu

# Bootstrap for macOS
echo "Detected macOS - starting bootstrap..."

# Install Homebrew if not present
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete Xcode Command Line Tools installation and re-run 'chezmoi apply'"
    exit 1
fi

echo "Installing essential packages..."
brew install git curl wget zsh 1password-cli

# Install Oh My Zsh (before dotfiles get applied)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    if command -v zsh >/dev/null 2>&1; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "zsh not found, skipping Oh My Zsh installation"
    fi
else
    echo "Oh My Zsh already installed"
fi

echo "macOS bootstrap complete"