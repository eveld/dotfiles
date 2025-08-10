#!/bin/sh
set -eu

# Setup shell environment (zsh and Oh My Zsh)
# This script is cross-platform

echo "Setting up shell environment..."

# Set zsh as default shell
if command -v zsh >/dev/null 2>&1; then
    ZSH_PATH=$(command -v zsh)
    
    # Get current shell differently based on OS
    if [ "$(uname)" = "Darwin" ]; then
        CURRENT_SHELL="$SHELL"
    else
        CURRENT_SHELL=$(getent passwd "$(whoami)" | cut -d: -f7)
    fi
    
    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
        echo "Changing default shell to zsh..."
        if [ "$(uname)" = "Darwin" ]; then
            chsh -s "$ZSH_PATH"
        else
            sudo chsh -s "$ZSH_PATH" "$(whoami)"
        fi
        echo "Shell changed to zsh"
    else
        echo "zsh is already the default shell"
    fi
else
    echo "Error: zsh not found. Please install zsh first."
    exit 1
fi

# Oh My Zsh is now installed in bootstrap scripts (before dotfiles are applied)
echo "Oh My Zsh should already be installed from bootstrap"

echo "Shell setup complete"