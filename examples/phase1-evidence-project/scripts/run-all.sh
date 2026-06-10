#!/usr/bin/env bash

set -euo pipefail

mkdir -p .bb/tmp

echo "Validating config..."
bb config validate

echo "Checking readiness..."
bb doctor

echo "Running all Phase 1 adapters..."
bb run unit ui api perf sec

echo "Artifacts written under:"
find .bb/runs -maxdepth 2 -type d | sort | tail -n 20