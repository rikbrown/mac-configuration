#!/bin/sh

alias dw="defaults write"
alias dwg="defaults write -g"

sudo echo "Welcome to setup!" # cache sudo

#
# Apps
#

# Homebrew setup
echo "Setting up Homebrew"
[ ! -e /usr/local/bin/brew ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install brews
echo "Unbundling brews!"
brew bundle

#
# Config
#
echo "Configuring system"

# Keyboard
dwg NSAutomaticQuoteSubstitutionEnabled -bool false
dwg NSAutomaticDashSubstitutionEnabled -bool false
dwg NSAutomaticSpellingCorrectionEnabled -bool false
dwg NSAutomaticCapitalizationEnabled -bool false
dwg NSAutomaticPeriodSubstitutionEnabled -bool false
dwg NSPreferredSpellServerLanguage "en_GB"
dwg AppleKeyboardUIMode -int 3

# Mouse
dwg com.apple.mouse.scaling 5
dwg AppleEnableMouseSwipeNavigateWithScrolls -bool true
dwg MouseButtonMode "TwoButton"
dwg MouseTwoFingerHorizSwipeGesture 2
dwg MouseButtonDivision 55

# Finder
dw com.apple.finder NewWindowTarget -string "PfHm" # New window default location to ~
dw com.apple.frameworks.diskimages skip-verify true
dw com.apple.LaunchServices LSQuarantine -bool false # No "Are you sure you want to open?" msg
dwg NSTableViewDefaultSizeMode -int 1 # smaller sidebar icons
dw com.apple.finder ShowStatusBar -bool true
dw com.apple.finder ShowPathbar -bool true
dw com.apple.finder QLEnableTextSelection -bool true # text selection in quicklook
dw com.apple.desktopservices DSDontWriteNetworkStores -bool true
# default view mode to grid for desktop and list elsewhere
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy list" ~/Library/Preferences/com.apple.finder.plist
chflags nohidden ~/Library # show ~/Library

# Dock
dw com.apple.dock tilesize -int 32

# Mission Control
dw com.apple.dock mru-spaces -bool false # don't automatically rearrange spaces

# Dialogs
dwg NSNavPanelExpandedStateForSaveMode -bool true
dwg PMPrintingExpandedStateForPrint -bool true

# Menu
dw com.apple.menuextra.clock 'DateFormat' -string 'EEE MMM d  HH:mm'

# Git
git config --global author.name "Rik Brown"
git config --global author.email "rik@rik.codes"

# Power management
sudo pmset autorestart 1


#
# Terminal
#

# Set Fish as shell
echo "Setting Fish as shell"
sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"
chsh -s /usr/local/bin/fish

#
# Post-apps config
#

echo "Configuring apps"
defaults write com.apple.TextEdit RichText -int 0 # default to plain text

#
# Cleanup
#

echo "Cleaning up"

# Reset finder
echo "Killing your favourite processes"
killall Finder
killall Dock
killall SystemUIServer

# Dark mode
echo "Let's get dark"
dark-mode off 
dark-mode on

# 
# Open relevant installed apps so we can do things with them
#
echo "Opening apps"
open "/Applications/Alfred 3.app"
open /Applications/BetterSnapTool.app
open /Applications/Dropbox.app
