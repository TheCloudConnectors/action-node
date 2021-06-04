#!/bin/sh

set -e

NPM_CONFIG="${NPM_CONFIG:-"$HOME/.npmrc"}"
NPM_REGISTRY="${NPM_REGISTRY:-registry.npmjs.org}"

echo "registry=$NPM_REGISTRY" > $NPM_CONFIG
echo "always-auth=true" >> $NPM_CONFIG
echo $NPMRC >> $NPM_CONFIG

chmod 0600 "$NPM_CONFIG"

sh -c "yarn $*"