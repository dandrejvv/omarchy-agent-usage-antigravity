#!/usr/bin/env bash
set -euo pipefail

echo "=== Removing Google Antigravity Integration ==="

# Remove font
rm -f "$HOME/.local/share/fonts/antigravity.ttf"
fc-cache -f "$HOME/.local/share/fonts" 2>/dev/null || true

# Remove binaries
rm -f "$HOME/.local/bin/omarchy-agent-usage-antigravity"
rm -f "$HOME/.local/bin/omarchy-agent-usage-update"
rm -f "$HOME/.local/bin/omarchy-agent"
rm -f "$HOME/.local/bin/omarchy-default-agent"

# Remove plugin
rm -rf "$HOME/.config/omarchy/plugins/custom.agents"

# Revert shell.json
if [[ -f "$HOME/.config/omarchy/shell.json" ]]; then
  sed -i 's/"custom\.agents"/"omarchy.agents"/g' "$HOME/.config/omarchy/shell.json"
fi

# Clean menu extension
MENU_FILE="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"
if [[ -f "$MENU_FILE" ]]; then
  python3 - << 'PYEOF'
import json, os, re
path = os.path.expanduser("~/.config/omarchy/extensions/omarchy-menu.jsonc")
if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
    stripped = re.sub(r'//.*$', '', content, flags=re.MULTILINE)
    try:
        data = json.loads(stripped) if stripped.strip() else {}
        data.pop("setup.default.agent.antigravity", None)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
    except Exception:
        pass
PYEOF
fi

# Reset default agent if it was antigravity
if [[ "$(cat ~/.config/omarchy/defaults/agent 2>/dev/null)" == "antigravity" ]]; then
  rm -f "$HOME/.config/omarchy/defaults/agent"
fi

# Restart shell
if command -v omarchy >/dev/null 2>&1; then
  omarchy restart shell >/dev/null 2>&1 || true
fi

echo "=== Antigravity Integration Removed ==="
