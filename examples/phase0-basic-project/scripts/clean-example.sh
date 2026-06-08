#!/usr/bin/env bash

# clean-example.sh removes generated BrikByteOS runtime artifacts from this
# example project.
#
# Purpose:
#   Return the example directory to a clean teaching state after users run
#   `bb init`, `bb run`, `bb report`, or `bb gate`.
#
# This script removes only generated local example artifacts:
#   - bb.config.yaml
#   - .bb/
#
# It does not remove:
#   - README.md
#   - brikbyteos.yaml
#   - scripts/
#   - expected-output/

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
example_dir="$(cd "${script_dir}/.." && pwd)"

rm -rf "${example_dir}/.bb"
rm -f "${example_dir}/bb.config.yaml"

echo "Phase 0 basic example cleaned."