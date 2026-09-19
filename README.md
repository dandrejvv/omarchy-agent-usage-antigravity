# Google Antigravity Integration for Omarchy

Full Google Antigravity (`agy`) integration for the [Omarchy](https://github.com/basecamp/omarchy) desktop environment.

Provides a Quickshell top-bar widget with real-time token and quota progress bars, automated usage collection, custom vector brand assets, font glyphs, launcher wrappers, and Omarchy application menu integration.

---

## Features

- **Quickshell Bar Widget**: Displays live session/weekly quota utilization, token counts by model, and daily usage breakdowns in the Omarchy top bar and agent panel.
- **Background Usage Collector**: Automated collector (`omarchy-agent-usage-antigravity`) parsing `~/.gemini/antigravity-cli/` usage data according to Omarchy's agent usage schema (v1).
- **Brand Assets**: Custom dark-mode, light-mode, and monochrome SVG brand icons.
- **Font Glyph**: Vector compiled into `antigravity.ttf` (`U+E90E`) for seamless, theme-tinted rendering in the Omarchy menu.
- **Turnkey Setup**: One-line install and uninstall scripts with automatic backup and shell reload.

---

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/omarchy-agent-usage-antigravity.git
cd omarchy-agent-usage-antigravity
./install.sh
```

The installer will:
1. Copy the TTF font glyph to `~/.local/share/fonts/` and update font cache.
2. Install command wrappers and the collector to `~/.local/bin/`.
3. Install the `custom.agents` plugin to `~/.config/omarchy/plugins/custom.agents/`.
4. Update `~/.config/omarchy/shell.json` to activate `custom.agents`.
5. Register Antigravity in `~/.config/omarchy/extensions/omarchy-menu.jsonc`.
6. Set Antigravity as your default agent in `~/.config/omarchy/defaults/agent`.
7. Reload the Omarchy shell.

---

## Uninstallation

To restore stock Omarchy defaults and remove all Antigravity wrappers and plugins:

```bash
./uninstall.sh
```

---

## Upstream Contribution

To contribute this integration directly to the official `basecamp/omarchy` repository, follow the detailed instructions in [SUBMISSION.md](SUBMISSION.md).

---

## License

MIT License. See [LICENSE](LICENSE) for details.
