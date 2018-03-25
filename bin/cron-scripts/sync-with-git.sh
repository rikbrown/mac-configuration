#!/bin/sh

#
# Script to update Brewfile in Git based on "brew bundle dump".
# Requires the running user to be able to write to the configuration repo.
# Silent on success (intended to be used as cron).
#

set -e # exit if anything fails

TEMP_DIR="/tmp/sync-settings"

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
    git commit --quiet --author "sync-with-git (robot) <sync-with-git@$(hostname)>" -m "[sync-with-git] Update Brewfile" Brewfile
fi

# Backup configuration
rm -rf ./preferences/*
mkdir -p preferences
touch preferences/.gitignore
~/bin/mac-configuration/preferences/backup-preferences.rb -l preferences
git add -N preferences # mark intent to add preferences (so diff works)
if [ ! -z "$(git diff preferences)" ]; then
    git commit --quiet --author "sync-with-git (robot) <sync-with-git@$(hostname)>" -m "[sync-with-git] Update application preferences" preferences
fi

git push --quiet 2>&1

popd >/dev/null
rm -rf ${TEMP_DIR}
