#!/bin/sh
set -eu

# Final configuration after all packages are installed
echo "Configuring development environment..."

# Configure Git
echo "Configuring Git..."
git config --global user.name "Erik Veld"
git config --global user.email "mail@erikveld.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global push.autoSetupRemote true

# Setup 1Password SSH Agent
echo "Configuring 1Password SSH Agent..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "IdentityAgent" "$SSH_CONFIG" 2>/dev/null; then
    echo "Adding 1Password SSH agent configuration..."
    cat >>"$SSH_CONFIG" <<EOF

# Use 1Password SSH Agent
Host *
    IdentityAgent ~/.1password/agent.sock
    SetEnv TERM=xterm-256color

# Development containers and localhost
Host localhost
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no

EOF
    chmod 600 "$SSH_CONFIG"
else
    echo "1Password SSH agent already configured"
fi

# Check 1Password CLI authentication
if command -v op >/dev/null 2>&1 && op account list >/dev/null 2>&1; then
    echo "1Password CLI is configured"
else
    echo "1Password CLI needs configuration"
    echo "You can either:"
    echo "1. Enable 1Password desktop app integration"
    echo "2. Run 'op account add' manually"
fi

# Let chezmoi handle dotfile application - no manual copying needed

echo "Configuration complete"
echo "Note: Restart your shell or run 'exec zsh' to apply changes"

