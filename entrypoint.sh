#!/bin/sh

set -e

NPM_CONFIG="${NPM_CONFIG:-"$HOME/.npmrc"}"
NPM_REGISTRY="${NPM_REGISTRY:-registry.npmjs.org}"

echo "registry=$NPM_REGISTRY" > $NPM_CONFIG
echo "always-auth=true" >> $NPM_CONFIG
echo $NPMRC >> $NPM_CONFIG

chmod 0600 "$NPM_CONFIG"

CMD="$*"
if echo "$CMD" | grep -q "^install"; then
  sh -c "/root/.safe-chain/bin/safe-chain $(which yarn) install --frozen-lockfile"
else
  sh -c "yarn $CMD"
fi