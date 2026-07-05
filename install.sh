#!/usr/bin/env bash
# Install or update the codex-goals skill into the local Claude skills directory.
# Usage: ./install.sh            (installs to ~/.claude/skills/codex-goals)
#        CLAUDE_SKILLS_DIR=/path ./install.sh
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}/codex-goals"

mkdir -p "$DEST/references" "$DEST/assets"
cp "$SRC/SKILL.md" "$SRC/UPGRADE.md" "$SRC/CHANGELOG.md" "$DEST/"
cp "$SRC/references/goal-mode-mechanics.md" "$DEST/references/"
cp "$SRC/assets/goal-template.md" "$DEST/assets/"

VERSION="$(grep -m1 -oE '\[[0-9]+\.[0-9]+\.[0-9]+\]' "$SRC/CHANGELOG.md" | tr -d '[]' || echo 'unknown')"
echo "Installed codex-goals v$VERSION -> $DEST"
