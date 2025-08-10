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

echo "macOS bootstrap complete"