#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: scripts/bump-version.sh <version>" >&2
  exit 1
fi

version="$1"
root="$(cd "$(dirname "$0")/.." && pwd)"

python3 - "$root" "$version" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
version = sys.argv[2]
config = json.loads((root / ".version-bump.json").read_text())

for rel in config["files"]:
    path = root / rel
    data = json.loads(path.read_text())
    if "version" in data:
        data["version"] = version
    if rel == ".claude-plugin/marketplace.json":
        for plugin in data.get("plugins", []):
            plugin["version"] = version
    path.write_text(json.dumps(data, indent=2) + "\n")

config["currentVersion"] = version
(root / ".version-bump.json").write_text(json.dumps(config, indent=2) + "\n")
PY

echo "Updated version to $version"
