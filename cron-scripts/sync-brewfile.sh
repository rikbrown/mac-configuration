#!/bin/sh

#
# Script to update Brewfile in Git based on "brew bundle dump".
# Requires the running user to be able to write to the configuration repo.
# Silent on success (intended to be used as cron).
#

set -e # exit if anything fails

TEMP_DIR="/tmp/sync-brewfile"

# Create temporary directory
[ -e ${TEMP_DIR} ] && rm -rf ${TEMP_DIR}
mkdir -p ${TEMP_DIR}
pushd ${TEMP_DIR} >/dev/null

# Clone config
git clone --quiet git@github.com:rikbrown/rik-mac-configuration.git mac-configuration
cd mac-configuration

# Update bundle
brew bundle dump --force

if [ ! -z "$(git diff Brewfile)" ]; then
    git commit --quiet -m "[sync-brewfile] Update Brewfile" Brewfile
    git push --quiet 2>&1
fi

popd >/dev/null
rm -rf ${TEMP_DIR}
