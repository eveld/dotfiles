#!/bin/sh
set -eu

# Install development packages for Debian/Ubuntu
echo "Installing Debian/Ubuntu packages..."

echo "Installing packages via apt..."
sudo apt update
sudo apt install -y \
    build-essential \
    direnv \
    fd-find \
    fzf \
    mosh \
    neovim \
    ripgrep \
    tmux

# Install tools not in default repos
echo "Installing additional tools..."

# Install bottom
if ! command -v btm >/dev/null 2>&1; then
    echo "Installing bottom..."
    curl -LO https://github.com/ClementTsang/bottom/releases/latest/download/bottom_x86_64-unknown-linux-musl.tar.gz
    tar -xzf bottom_x86_64-unknown-linux-musl.tar.gz
    sudo mv btm /usr/local/bin/
    rm bottom_x86_64-unknown-linux-musl.tar.gz
fi

# Install lazygit
if ! command -v lazygit >/dev/null 2>&1; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
fi

# Install zellij
if ! command -v zellij >/dev/null 2>&1; then
    echo "Installing zellij..."
    curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar -xz -C /tmp
    sudo mv /tmp/zellij /usr/local/bin/
fi

# Install Go from official releases (Ubuntu's Go is too old)
if ! command -v go >/dev/null 2>&1; then
    echo "Fetching latest stable Go version..."
    
    # Get latest stable Go version from official API using pure shell commands
    LATEST_GO_JSON=$(curl -s "https://go.dev/dl/?mode=json")
    if [ $? -ne 0 ] || [ -z "$LATEST_GO_JSON" ]; then
        echo "Failed to fetch Go version info, using fallback version 1.23.4"
        GO_VERSION="1.23.4"
    else
        # Extract latest stable version (first entry in JSON array) using grep/sed
        # Look for the first "version": "goX.Y.Z" pattern
        LATEST_GO=$(echo "$LATEST_GO_JSON" | grep -o '"version":"go[^"]*"' | head -1 | sed 's/"version":"go\([^"]*\)"/\1/')
        if [ -z "$LATEST_GO" ]; then
            echo "Failed to parse Go version, using fallback version 1.23.4"
            GO_VERSION="1.23.4"
        else
            GO_VERSION="$LATEST_GO"
            echo "Latest stable Go version: $GO_VERSION"
        fi
    fi
    
    # Detect architecture
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64) GO_ARCH="amd64" ;;
        aarch64|arm64) GO_ARCH="arm64" ;;
        *) echo "Unsupported architecture: $ARCH, using amd64"; GO_ARCH="amd64" ;;
    esac
    
    echo "Installing Go $GO_VERSION for linux-$GO_ARCH..."
    GO_TARBALL="go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
    
    if curl -LO "https://go.dev/dl/$GO_TARBALL"; then
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$GO_TARBALL"
        rm "$GO_TARBALL"
        
        # Add Go to PATH for current session
        export PATH="/usr/local/go/bin:$PATH"
        echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.zshrc
        
        echo "Go $GO_VERSION installed successfully"
    else
        echo "Failed to download Go $GO_VERSION, installation failed"
        exit 1
    fi
fi

# Install Go tools with error handling (disable exit-on-error temporarily)
set +e
if command -v go >/dev/null 2>&1 || [ -x "/usr/local/go/bin/go" ]; then
    echo "Installing Go tools..."
    # Use explicit path if go not in PATH yet
    GO_CMD="go"
    if [ ! -x "$(command -v go)" ] && [ -x "/usr/local/go/bin/go" ]; then
        GO_CMD="/usr/local/go/bin/go"
        export PATH="/usr/local/go/bin:$PATH"
    fi
    
    # Get Go version for compatibility decisions
    GO_VERSION_OUTPUT=$($GO_CMD version 2>/dev/null | cut -d' ' -f3)
    GO_MAJOR_MINOR=$(echo "${GO_VERSION_OUTPUT#go}" | cut -d. -f1-2)
    
    echo "Go version: $GO_VERSION_OUTPUT (major.minor: $GO_MAJOR_MINOR)"
    
    # Install gopls with error handling
    echo "Installing gopls..."
    if $GO_CMD install golang.org/x/tools/gopls@latest 2>/dev/null; then
        echo "✓ gopls installed successfully"
    else
        echo "✗ gopls installation failed, trying stable version..."
        if $GO_CMD install golang.org/x/tools/gopls@v0.16.2 2>/dev/null; then
            echo "✓ gopls v0.16.2 installed successfully" 
        else
            echo "✗ gopls installation failed completely, skipping"
        fi
    fi
    
    # Install delve with error handling  
    echo "Installing delve debugger..."
    if $GO_CMD install github.com/go-delve/delve/cmd/dlv@latest 2>/dev/null; then
        echo "✓ delve installed successfully"
    else
        echo "✗ delve installation failed, skipping"
    fi
    
    echo "Go tools installation completed"
else
    echo "Go not found, skipping Go tools installation"
fi
# Re-enable exit-on-error
set -e

echo "Debian/Ubuntu package installation complete"