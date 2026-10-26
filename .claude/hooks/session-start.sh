#!/bin/bash
# SessionStart hook for Claude Code cloud sessions: installs Python and
# Remotion dependencies so preflight, tests and renders work out of the box.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

python3 -m pip install -q -r requirements-dev.txt
# Free offline TTS (voice models still need a reachable huggingface.co).
python3 -m pip install -q piper-tts || true

(cd remotion-composer && npm install --no-audit --no-fund)

# Remotion can't download its own headless shell here; reuse the container's.
for browser in /opt/pw-browsers/chromium_headless_shell-*/chrome-linux/headless_shell /opt/pw-browsers/chromium; do
  if [ -x "$browser" ]; then
    if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
      echo "export REMOTION_BROWSER_EXECUTABLE=\"$browser\"" >> "$CLAUDE_ENV_FILE"
    fi
    break
  fi
done
