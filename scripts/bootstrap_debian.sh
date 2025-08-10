#!/bin/sh
set -eu

# Bootstrap for Debian/Ubuntu
echo "Detected Debian/Ubuntu - starting bootstrap..."

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install essential packages
echo "Installing essential packages..."
sudo apt install -y git curl wget ca-certificates gnupg lsb-release zsh

# Install 1Password CLI
if ! command -v op >/dev/null 2>&1; then
    echo "Installing 1Password CLI..."
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
        sudo tee /etc/apt/sources.list.d/1password.list
    
    sudo apt update && sudo apt install -y 1password-cli
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

echo "Debian/Ubuntu bootstrap complete"