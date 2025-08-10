#!/bin/sh
set -eu

# Bootstrap for Arch Linux
echo "Detected Arch Linux - starting bootstrap..."

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install essential packages
echo "Installing essential packages..."
sudo pacman -S --noconfirm git curl wget unzip zsh

# Install 1Password CLI
if ! command -v op >/dev/null 2>&1; then
    echo "Installing 1Password CLI..."
    OP_URL=$(curl -s https://app-updates.agilebits.com/product_history/CLI2 | grep -o 'https://[^"]*linux_amd64[^"]*\.zip' | head -1)
    curl -sSO "$OP_URL"
    unzip -q op_linux_amd64_*.zip
    sudo mv op /usr/local/bin/
    rm -f op_linux_amd64_*.zip
fi

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

echo "Arch Linux bootstrap complete"