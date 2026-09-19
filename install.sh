#!/usr/bin/env bash
set -euo pipefail

# Self-contained installer for Google Antigravity in Omarchy
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Installing Google Antigravity Integration in Omarchy ==="

# 1. Install TTF font
echo "--> Installing Antigravity font glyph..."
mkdir -p "$HOME/.local/share/fonts"
cp "$SCRIPT_DIR/assets/antigravity.ttf" "$HOME/.local/share/fonts/antigravity.ttf"
fc-cache -f "$HOME/.local/share/fonts"
echo "    Font verified: $(fc-match antigravity)"

# 2. Install binaries & wrappers
echo "--> Installing command wrappers into ~/.local/bin/..."
mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/bin/omarchy-agent-usage-antigravity" "$HOME/.local/bin/"
cp "$SCRIPT_DIR/bin/omarchy-agent-usage-update" "$HOME/.local/bin/"
cp "$SCRIPT_DIR/bin/omarchy-agent" "$HOME/.local/bin/"
cp "$SCRIPT_DIR/bin/omarchy-default-agent" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/omarchy-"*

# 3. Ensure ~/.local/bin in ~/.bashrc before non-interactive return
if ! grep -q 'export PATH="\$HOME/\.local/bin:\$PATH"' "$HOME/.bashrc" 2>/dev/null; then
  echo "--> Ensuring ~/.local/bin precedence in ~/.bashrc..."
  sed -i '/env-bootstrap/a export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"
fi

# 4. Install custom.agents shell plugin
echo "--> Installing custom.agents shell plugin..."
mkdir -p "$HOME/.config/omarchy/plugins/custom.agents/assets"
cp -r "$SCRIPT_DIR/plugin/"* "$HOME/.config/omarchy/plugins/custom.agents/"

# 5. Configure shell.json
echo "--> Updating bar layout in ~/.config/omarchy/shell.json..."
if [[ -f "$HOME/.config/omarchy/shell.json" ]]; then
  if grep -q '"omarchy.agents"' "$HOME/.config/omarchy/shell.json"; then
    cp "$HOME/.config/omarchy/shell.json" "$HOME/.config/omarchy/shell.json.bak.$(date +%s)"
    sed -i 's/"omarchy\.agents"/"custom.agents"/g' "$HOME/.config/omarchy/shell.json"
  fi
fi

# 6. Configure Menu Extension
echo "--> Registering menu extension in ~/.config/omarchy/extensions/omarchy-menu.jsonc..."
mkdir -p "$HOME/.config/omarchy/extensions"
MENU_FILE="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"

python3 - << 'PYEOF'
import json, os, re

path = os.path.expanduser("~/.config/omarchy/extensions/omarchy-menu.jsonc")
entry = {
    "icon": "",
    "iconFont": "antigravity",
    "label": "Antigravity",
    "checked": '[[ "$(omarchy-default-agent)" == "antigravity" ]]',
    "action": "mkdir -p ~/.config/omarchy/defaults && printf 'antigravity\\n' > ~/.config/omarchy/defaults/agent && omarchy-launch-tui --app-id=org.omarchy.agent agy --dangerously-skip-permissions"
}

data = {}
if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
    # Strip single line comments for parsing
    stripped = re.sub(r'//.*$', '', content, flags=re.MULTILINE)
    try:
        data = json.loads(stripped) if stripped.strip() else {}
    except Exception:
        data = {}

data["setup.default.agent.antigravity"] = entry
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
PYEOF

# 7. Set default agent
echo "--> Setting default agent to antigravity..."
mkdir -p "$HOME/.config/omarchy/defaults"
printf 'antigravity\n' > "$HOME/.config/omarchy/defaults/agent"

# 8. Generate usage snapshot
echo "--> Generating initial agent usage snapshot..."
"$HOME/.local/bin/omarchy-agent-usage-antigravity" --force >/dev/null

# 9. Restart shell if running
if command -v omarchy >/dev/null 2>&1; then
  echo "--> Reloading Omarchy shell..."
  omarchy restart shell >/dev/null 2>&1 || true
fi

echo ""
echo "=== Antigravity Installation Complete! ==="
echo "Default agent: $(omarchy-default-agent)"
echo "Usage file:    ~/.local/state/omarchy/agents/usage/antigravity.json"
