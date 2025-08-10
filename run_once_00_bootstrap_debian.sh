#!/bin/sh
set -eu

# Bootstrap for Debian/Ubuntu
echo "Bootstrapping Debian/Ubuntu environment..."

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

echo "Debian/Ubuntu bootstrap complete"