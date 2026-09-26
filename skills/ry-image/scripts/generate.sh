#!/usr/bin/env bash
# Bridge RY_IMAGE_* into one upstream gpt-image CLI process.
# Does not rewrite requests, choose providers, or touch the parent environment.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
UPSTREAM_GENERATOR="$SCRIPT_DIR/../../gpt-image/scripts/generate.py"

if [[ ! -f "$UPSTREAM_GENERATOR" ]]; then
  echo "error: upstream generator not found: $UPSTREAM_GENERATOR" >&2
  exit 2
fi

: "${RY_IMAGE_API_KEY:?RY_IMAGE_API_KEY is required}"
: "${RY_IMAGE_BASE_URL:?RY_IMAGE_BASE_URL is required}"

MODEL="${RY_IMAGE_MODEL:-image}"

exec env \
  OPENAI_API_KEY="$RY_IMAGE_API_KEY" \
  OPENAI_BASE_URL="$RY_IMAGE_BASE_URL" \
  uv run "$UPSTREAM_GENERATOR" \
  --model "$MODEL" \
  "$@"
