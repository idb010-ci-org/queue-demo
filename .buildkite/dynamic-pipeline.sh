#!/bin/bash
# Adapted from raw-docs/integrations/buildkite.md "Dynamic pipeline script" (~line 137).
# `buildkite-agent` is a shim provided by the idb-010 runner with the same CLI surface
# (meta-data get/set, pipeline upload) so this documented script runs unmodified.
set -euo pipefail

SCOPES=$(buildkite-agent meta-data get "mergify-ci.scopes" --default '{}')

echo "steps:"

if echo "$SCOPES" | jq -e '.api == "true"' > /dev/null 2>&1; then
  cat <<'YAML'
  - label: ":python: API tests"
    command: .buildkite/run-scope-tests.sh api
YAML
fi

if echo "$SCOPES" | jq -e '.frontend == "true"' > /dev/null 2>&1; then
  cat <<'YAML'
  - label: ":react: Frontend tests"
    command: .buildkite/run-scope-tests.sh frontend
YAML
fi

if echo "$SCOPES" | jq -e '.docs == "true"' > /dev/null 2>&1; then
  cat <<'YAML'
  - label: ":books: Docs tests"
    command: .buildkite/run-scope-tests.sh docs
YAML
fi
