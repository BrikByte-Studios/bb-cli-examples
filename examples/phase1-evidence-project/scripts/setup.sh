#!/usr/bin/env bash

set -euo pipefail

echo "Installing Node dependencies..."
pnpm install

echo "Installing Playwright browsers..."
pnpm exec playwright install --with-deps chromium

echo "Checking optional external tools..."
command -v k6 >/dev/null 2>&1 || echo "WARN: k6 not found. Install k6 before running performance adapter."
command -v trivy >/dev/null 2>&1 || echo "WARN: trivy not found. Install Trivy before running security adapter."

echo "Setup complete."