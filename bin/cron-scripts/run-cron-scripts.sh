#!/bin/sh

~/bin/mac-configuration/cron-scripts/upgrade-brews.sh
~/bin/mac-configuration/cron-scripts/sync-with-git.sh

# Go back to sleep if not in an interactive shell
if [ "$1" == "--sleep" ]; then
    pmset sleepnow
fi