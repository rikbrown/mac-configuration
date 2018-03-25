#!/bin/sh
set -e # exit if anything fails

TEMP_DIR="/tmp/sync-brewfile"

# Create temporary directory
[ -e ${TEMP_DIR} ] && rm -rf ${TEMP_DIR}
mkdir -p ${TEMP_DIR}
pushd ${TEMP_DIR} >/dev/null

# Clone config
git clone --quiet git@github.com:rikbrown/rik-mac-configuration.git rik-mac-configuration
cd rik-mac-configuration

# Update bundle
./update-bundle.sh

if [ ! -z "$(git diff Brewfile)" ]; then
    git commit --quiet -m "[sync-brewfile] Update installed applications" Brewfile
    git push --quiet 2>&1
fi

popd >/dev/null