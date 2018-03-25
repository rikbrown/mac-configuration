#!/bin/sh
set -e

sudo -S -v <<< 'SECRETPASSWORD' 2> /dev/null
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew upgrade >/dev/null
brew cask upgrade >/dev/null
brew cleanup -s >/dev/null
brew cask cleanup >/dev/null
