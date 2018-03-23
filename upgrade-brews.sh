#!/bin/sh
sudo -S -v <<< 'SECRETPASSWORD' 2> /dev/null
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew upgrade
brew cask upgrade
brew cleanup -s
brew cask cleanup