#!/bin/sh
set -eu

# Install Oh My Zsh after packages but before final configuration
echo "Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if command -v zsh >/dev/null 2>&1; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        echo "Oh My Zsh installed"
    else
        echo "Error: zsh not found. Cannot install Oh My Zsh."
        exit 1
    fi
else
    echo "Oh My Zsh already installed"
fi

echo "Oh My Zsh setup complete"