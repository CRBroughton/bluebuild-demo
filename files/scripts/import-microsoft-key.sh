#!/bin/bash
set -euo pipefail

# Import Microsoft GPG key for VS Code repository
rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo "Microsoft GPG key imported"