#!/bin/bash
set -euo pipefail

# Enable smart card daemon for YubiKey support
systemctl enable pcscd

echo "YubiKey smart card daemon enabled"