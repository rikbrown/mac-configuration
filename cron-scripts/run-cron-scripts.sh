#!/bin/sh

~/bin/mac-configuration/upgrade-brews.sh
~/bin/mac-configuration/sync-brewfile.sh

# Go back to sleep if not in an interactive shell
if [ "$1" == "--sleep" ]; then
    pmset sleepnow
fi