#!/bin/bash
set -euo pipefail

echo "Installing latest Go..."

# Get latest Go version
GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n1)
GO_TARBALL="$GO_VERSION.linux-amd64.tar.gz"

echo "Downloading Go $GO_VERSION..."

# Download Go
cd /tmp
wget "https://go.dev/dl/$GO_TARBALL"

# Remove any existing Go installation and extract new one
echo "Installing Go to /usr/local/go..."
rm -rf /usr/local/go
tar -C /usr/local -xzf "$GO_TARBALL"

# Set proper permissions
chown -R root:root /usr/local/go

# Clean up
rm -f "$GO_TARBALL"

# Create profile script for PATH
echo "Setting up Go environment..."
cat > /etc/profile.d/go.sh << 'EOF'
#!/bin/bash
# Add Go to PATH
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
EOF

chmod +x /etc/profile.d/go.sh

echo "Go installation completed: $GO_VERSION"