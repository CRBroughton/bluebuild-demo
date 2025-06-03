#!/usr/bin/env bash

# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

dnf copr enable pgdev/ghostty
dnf install ghostty
