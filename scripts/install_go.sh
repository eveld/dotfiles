#!/bin/sh
# Shared Go installation script - works across all platforms

install_go() {
    if command -v go >/dev/null 2>&1; then
        echo "Go already installed: $(go version)"
        return 0
    fi

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
    
    # Detect OS and architecture
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64) GO_ARCH="amd64" ;;
        aarch64|arm64) GO_ARCH="arm64" ;;
        *) echo "Unsupported architecture: $ARCH, using amd64"; GO_ARCH="amd64" ;;
    esac
    
    echo "Installing Go $GO_VERSION for $OS-$GO_ARCH..."
    GO_TARBALL="go${GO_VERSION}.${OS}-${GO_ARCH}.tar.gz"
    
    if curl -LO "https://go.dev/dl/$GO_TARBALL"; then
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$GO_TARBALL"
        rm "$GO_TARBALL"
        
        # Add Go to PATH for current session
        export PATH="/usr/local/go/bin:$PATH"
        echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.zshrc
        
        echo "Go $GO_VERSION installed successfully"
        return 0
    else
        echo "Failed to download Go $GO_VERSION"
        return 1
    fi
}

install_go_tools() {
    # Use explicit path if go not in PATH yet
    GO_CMD="go"
    if [ ! -x "$(command -v go)" ] && [ -x "/usr/local/go/bin/go" ]; then
        GO_CMD="/usr/local/go/bin/go"
        export PATH="/usr/local/go/bin:$PATH"
    fi
    
    if ! command -v "$GO_CMD" >/dev/null 2>&1; then
        echo "Go not found, skipping Go tools installation"
        return 1
    fi

    # Get Go version for compatibility decisions
    GO_VERSION_OUTPUT=$($GO_CMD version 2>/dev/null | cut -d' ' -f3)
    GO_MAJOR_MINOR=$(echo "${GO_VERSION_OUTPUT#go}" | cut -d. -f1-2)
    
    echo "Go version: $GO_VERSION_OUTPUT (major.minor: $GO_MAJOR_MINOR)"
    
    # Disable exit-on-error temporarily for tool installation
    set +e
    
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
    
    # Re-enable exit-on-error
    set -e
    
    echo "Go tools installation completed"
    return 0
}