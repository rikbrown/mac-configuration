#!/bin/sh
set -e


sudo -S -v <<< 'SECRETPASSWORD'
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew upgrade
brew cask upgrade

# Some apps are marked as auto-update, but are tedious to autoupdate (IntelliJ makes you download a dmg, the horror!)
brew cask upgrade intellij-idea iterm2 logitech-options

brew cleanup -s
