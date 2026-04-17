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
if echo "$CMD" | grep -q "^install"; then
  yarn install --frozen-lockfile
else
  yarn $CMD
fi
