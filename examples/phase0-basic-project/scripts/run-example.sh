#!/usr/bin/env bash

# run-example.sh runs the complete BrikByteOS Phase 0 basic example.
#
# Purpose:
#   Provide one safe command that new users can run to see the Phase 0 workflow:
#
#     version -> init -> doctor -> config validate -> run -> report -> gate
#
# Safety:
#   - uses the `bb` binary found on PATH unless BB is provided
#   - does not call private services
#   - only writes local BrikByteOS runtime artifacts in this example directory
#   - fails fast on command errors
#
# Environment:
#   BB=/path/to/bb  Optional explicit bb binary path.
#
# Usage:
#   ./scripts/run-example.sh
#   BB="$HOME/.local/bin/bb" ./scripts/run-example.sh

set -euo pipefail

BB="${BB:-bb}"

fail() {
  echo "phase0-basic-project failed: $*" >&2
  exit 1
}

log() {
  echo ""
  echo "==> $*"
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    fail "required command not found: ${command_name}. Install bb first."
  fi
}

project_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd "${script_dir}/.." && pwd
}

main() {
  local root
  root="$(project_root)"

  if [[ "${BB}" == */* ]]; then
    [[ -x "${BB}" ]] || fail "BB is not executable: ${BB}"
  else
    require_command "${BB}"
  fi

  cd "${root}"

  log "Using bb binary"
  "${BB}" version

  log "Running demo script"
  ./scripts/hello.sh

  log "Initializing BrikByteOS project"
  "${BB}" init

  log "Running doctor"
  "${BB}" doctor

  log "Validating config"
  "${BB}" config validate

  log "Running Phase 0 adapter"
  "${BB}" run

  log "Generating report"
  "${BB}" report

  log "Evaluating gate"
  "${BB}" gate

  log "Phase 0 basic example completed"
}

main "$@"