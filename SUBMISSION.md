# Google Antigravity Integration Upstream Submission

This guide describes how to submit the Antigravity integration upstream to `basecamp/omarchy`.

## Package Directory Structure

```
~/Projects/omarchy-agent-usage-antigravity/
├── assets/
│   ├── antigravity.svg            # Dark-mode multi-color SVG brand mark
│   ├── antigravity-light.svg      # Light-mode multi-color SVG brand mark
│   └── antigravity-monochrome.svg # Monochrome SVG outline for font compilation
├── bin/
│   └── omarchy-agent-usage-antigravity # Python collector script
├── test-local.sh                  # Local test script
└── SUBMISSION.md                  # Step-by-step PR guide for basecamp/omarchy
```

## Step-by-Step Upstream Contribution Process

### 1. Fork & Clone Upstream Repository
```bash
gh repo fork basecamp/omarchy --clone
cd omarchy
git checkout -b feat-antigravity-agent
```

### 2. Copy Collector & Assets
```bash
SRC="$HOME/Projects/omarchy-agent-usage-antigravity"
cp "$SRC/bin/omarchy-agent-usage-antigravity" bin/
chmod +x bin/omarchy-agent-usage-antigravity
cp "$SRC/assets/antigravity.svg" shell/plugins/agents/assets/
cp "$SRC/assets/antigravity-light.svg" shell/plugins/agents/assets/
```

### 3. Append Font Glyph
Append the monochrome silhouette to Omarchy's icon font:
```bash
omarchy dev font add antigravity "$SRC/assets/antigravity-monochrome.svg"
```

### 4. Register in Upstream Defaults
- In `default/omarchy/omarchy-menu.jsonc`, add under `setup.default.agent`:
  ```jsonc
  "setup.default.agent.antigravity": {"icon":"","iconFont":"omarchy","label":"Antigravity","checked":"[[ \"$(omarchy-default-agent)\" == \"antigravity\" ]]","action":"omarchy-default-agent antigravity"},
  ```
- In `bin/omarchy-default-agent`:
  Add case:
  ```bash
  antigravity | agy) agent="antigravity"; name="Antigravity" ;;
  ```
- In `bin/omarchy-agent`:
  Add case:
  ```bash
  antigravity | agy)
    command=(agy --dangerously-skip-permissions)
    [[ -n ${prompt:-} ]] && command+=(--prompt "$prompt")
    ;;
  ```

### 5. Test & Submit Pull Request
```bash
# Verify local collector
./bin/omarchy-agent-usage-antigravity --force | jq .

# Commit and create PR
git add bin/omarchy-agent-usage-antigravity shell/plugins/agents/assets/antigravity*.svg default/omarchy/omarchy-menu.jsonc bin/omarchy-default-agent bin/omarchy-agent
git commit -m "feat(agents): add Google Antigravity usage collector and brand assets"
gh pr create --title "feat(agents): add Google Antigravity integration" --body "Adds Google Antigravity (agy) default agent launcher, usage collector, and SVG/font icon assets."
```
