#!/bin/sh
export PATH="/usr/local/bin/:$PATH"

chronic ~/bin/mac-configuration/cron-scripts/upgrade-brews.sh
chronic ~/bin/mac-configuration/cron-scripts/sync-with-git.sh

# Go back to sleep if not in an interactive shell
if [ "$1" == "--sleep" ]; then
    chronic pmset sleepnow
fi
