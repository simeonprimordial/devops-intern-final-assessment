#!/usr/bin/env bash

set -euo pipefail

echo "=== DevOps System Information ==="
echo "Current user: $(whoami)"
echo "Current date: $(date)"
echo
echo "=== Disk Usage ==="
df -h
