#!/bin/sh

alias dw="defaults write"
alias dwg="defaults write -g"
alias bi="brew install"
alias bci="brew cask install"

sudo echo "Welcome to setup!" # cache sudo

#
# Defaults
#
echo "Configuring defaults"

# Keyboard
dwg NSAutomaticQuoteSubstitutionEnabled -bool false
dwg NSAutomaticDashSubstitutionEnabled -bool false
dwg NSAutomaticSpellingCorrectionEnabled -bool false
dwg NSAutomaticCapitalizationEnabled -bool false
dwg NSAutomaticPeriodSubstitutionEnabled -bool false
dwg NSPreferredSpellServerLanguage "en_GB"

# Mouse
dwg com.apple.mouse.scaling 4
dwg AppleEnableMouseSwipeNavigateWithScrolls -bool true
dwg MouseButtonMode "TwoButton"
dwg MouseTwoFingerHorizSwipeGesture 2
dwg MouseButtonDivision 55

# Disable disk image verify
dw com.apple.frameworks.diskimages skip-verify true

# Homebrew setup
echo "Setting up Homebrew"
[ ! -e /usr/local/bin/brew ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install brews
brew bundle

# App store
mas lucky BetterSnapTool

# Fish 
sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"
chsh -s /usr/local/bin/fish

# Dark mode
dark-mode off 
dark-mode on

# Git
git config --global author.name "Rik Brown"
git config --global author.email "rik@rik.codes"

# Open relevant installed apps
open "/Applications/Alfred 3.app"
open /Applications/BetterSnapTool.app
open /Applications/Dropbox.app