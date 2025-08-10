#!/bin/sh
set -eu

# Debug script to see the state after all installations
echo "=== DEBUG: Final state check ==="
echo "Current .zshrc size: $(wc -l ~/.zshrc 2>/dev/null | cut -d' ' -f1) lines"
echo "First line of .zshrc:"
head -1 ~/.zshrc 2>/dev/null || echo "No .zshrc found"
echo ""
echo "Oh My Zsh directory exists: $([ -d ~/.oh-my-zsh ] && echo 'YES' || echo 'NO')"
echo "Neovim config directory: $([ -d ~/.config/nvim ] && echo 'YES' || echo 'NO')"
echo "Neovim init.lua exists: $([ -f ~/.config/nvim/init.lua ] && echo 'YES' || echo 'NO')"
echo "Chezmoi source zshrc: $(ls -la ~/.local/share/chezmoi/dot_zshrc 2>/dev/null || echo 'NOT FOUND')"
echo "Chezmoi source nvim: $(ls -la ~/.local/share/chezmoi/dot_config/nvim/init.lua 2>/dev/null || echo 'NOT FOUND')"
echo "=================================="