#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLLECTOR="$SCRIPT_DIR/bin/omarchy-agent-usage-antigravity"

echo "=== Running Antigravity Usage Collector (Local Test) ==="
record=$("$COLLECTOR" --force)

if [[ -z "$record" ]]; then
  echo "Error: Collector returned empty output" >&2
  exit 1
fi

echo "$record" | jq .

schema_ver=$(echo "$record" | jq -r '.schemaVersion // empty')
id=$(echo "$record" | jq -r '.id // empty')
name=$(echo "$record" | jq -r '.name // empty')
ready=$(echo "$record" | jq -r '.ready // empty')
tier=$(echo "$record" | jq -r '.tierLabel // empty')

if [[ "$schema_ver" != "1" || "$id" != "antigravity" ]]; then
  echo "Error: Schema validation failed! schemaVersion=$schema_ver, id=$id" >&2
  exit 1
fi

echo ""
echo "=== Test Successful ==="
echo "Agent: $name ($id)"
echo "Plan Tier: $tier"
echo "Ready: $ready"
echo "Today Prompts: $(echo "$record" | jq -r .todayPrompts)"
echo "Today Total Tokens: $(echo "$record" | jq -r .todayTotalTokens)"
echo "Limits: $(echo "$record" | jq -c .limits)"
