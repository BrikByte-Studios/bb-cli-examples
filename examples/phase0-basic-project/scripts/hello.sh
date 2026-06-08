#!/usr/bin/env bash

# hello.sh is a harmless demo script for the Phase 0 basic example.
#
# Purpose:
#   Show users where small project-local scripts can live in a BrikByteOS-style
#   project.
#
# Safety:
#   - does not read secrets
#   - does not call external services
#   - does not mutate files
#   - does not require private dependencies

set -euo pipefail

echo "Hello from BrikByteOS Phase 0 basic project."