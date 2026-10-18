#!/bin/bash
# Benign per-scope "test" step for the idb-010 fixture.
set -euo pipefail
SCOPE=$1
echo "running tests for scope: $SCOPE"
echo "files in area:"; ls -1 "services/$SCOPE" "apps/$SCOPE" "docs" 2>/dev/null | head -20 || true
echo "scope $SCOPE tests: OK"
