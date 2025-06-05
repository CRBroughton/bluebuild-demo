#!/bin/bash
set -euo pipefail

echo "Installing Bun..."

# Install Bun using official installer
curl -fsSL https://bun.sh/install | bash

echo "Bun installation completed"