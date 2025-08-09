#!/bin/sh
set -eu

# Configure development environment
# This runs once when dotfiles are first applied

echo "Configuring development environment..."

# Configure Git with user information
configure_git() {
  echo "Configuring Git..."

  # Set user name and email (replace with your actual details)
  git config --global user.name "Erik Veld"
  git config --global user.email "mail@erikveld.com"

  # Set useful Git defaults
  git config --global init.defaultBranch main
  git config --global pull.rebase true
  git config --global push.autoSetupRemote true
}

# Setup 1Password SSH Agent
setup_1password_ssh() {
  echo "Configuring 1Password SSH Agent..."

  # Create SSH config directory if it doesn't exist
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  # Configure SSH to use 1Password agent
  SSH_CONFIG="$HOME/.ssh/config"

  # Check if 1Password SSH agent config already exists
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
}

# Setup shell configuration
configure_shell() {
  echo "Configuring shell..."

  # Ensure zsh is the default shell
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
  fi

  # Configure Oh My Zsh theme (this will be handled by dotfiles)
  echo "Shell configuration will be applied via dotfiles"
}

# Setup FZF key bindings and completion
setup_fzf() {
  echo "Setting up FZF..."

  # FZF key bindings and completion are typically handled by package managers
  # or Oh My Zsh plugins, so this is mostly a placeholder

  if command -v fzf >/dev/null 2>&1; then
    echo "FZF is installed and will be configured via dotfiles"
  fi
}

# Main execution
main() {
  configure_git
  setup_1password_ssh
  configure_shell
  setup_fzf

  echo "Configuration complete"
  echo "Note: Restart your shell or run 'exec zsh' to apply changes"
}

main

