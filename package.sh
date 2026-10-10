#!/usr/bin/env bash
set -euo pipefail

# Build a portable distribution archive of the Antigravity integration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE_NAME="omarchy-agent-usage-antigravity.tar.gz"
OUTPUT_PATH="$SCRIPT_DIR/$ARCHIVE_NAME"

echo "=== Building portable release bundle ==="

# Clean any temporary files
cd "$SCRIPT_DIR/.."
tar --exclude='.git' \
    --exclude='*.tar.gz' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    -czvf "$OUTPUT_PATH" \
    omarchy-agent-usage-antigravity

echo ""
echo "=== Bundle created successfully! ==="
echo "Path: $OUTPUT_PATH"
echo "Size: $(du -h "$OUTPUT_PATH" | cut -f1)"
echo ""
echo "To install on any new Omarchy machine:"
echo "  1. Copy $ARCHIVE_NAME to the new machine"
echo "  2. tar -xzf $ARCHIVE_NAME"
echo "  3. cd omarchy-agent-usage-antigravity && ./install.sh"
