#!/bin/bash
set -euo pipefail

echo "Installing Volta..."

# Install Volta using official installer
curl https://get.volta.sh | bash

# Add Fish support since Volta installer only handles bash/zsh
mkdir -p /etc/fish/conf.d
cat > /etc/fish/conf.d/volta.fish << 'EOF'
# Volta setup for Fish
set -gx VOLTA_HOME $HOME/.volta
set -gx PATH $VOLTA_HOME/bin $PATH
EOF

echo "Volta installation completed"