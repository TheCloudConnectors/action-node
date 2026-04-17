#!/bin/sh

set -e

# Force HOME=/root so Aikido Safe Chain shims can find their config/binary
# GitHub Actions overrides HOME to /github/home at runtime via docker -e HOME
export HOME=/root

NPM_CONFIG="${NPM_CONFIG:-"$HOME/.npmrc"}"
NPM_REGISTRY="${NPM_REGISTRY:-registry.npmjs.org}"

echo "registry=$NPM_REGISTRY" > $NPM_CONFIG
echo "always-auth=true" >> $NPM_CONFIG
echo $NPMRC >> $NPM_CONFIG

chmod 0600 "$NPM_CONFIG"

CMD="$*"

# Debug: verify safe-chain is active
echo "[debug] whoami: $(whoami)"
echo "[debug] which yarn: $(which yarn)"
echo "[debug] HOME=$HOME"
echo "[debug] safe-chain binary accessible: $(test -x /root/.safe-chain/bin/safe-chain && echo 'YES' || echo 'NO')"
echo "[debug] safe-chain version: $(/root/.safe-chain/bin/safe-chain --version 2>&1 || echo 'FAILED')"
echo "[debug] yarn safe-chain-verify: $(yarn safe-chain-verify 2>&1 || echo 'FAILED')"

if echo "$CMD" | grep -q "^install"; then
  yarn install --frozen-lockfile
else
  yarn $CMD
fi
