#!/bin/sh
alias dw="defaults write"
alias dwg="defaults write -g"
IS_SETUP=$(defaults read codes.rik.macconfig IsSetup 2>/dev/null)
USER=$(whoami)

#
# Initial prep
#

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

# Get password. We'll use it later for the update script
echo "Please enter your password:"
read -s PASSWORD
sudo -S -v <<< "$PASSWORD" 2>/dev/null

# Keep-alive: update existing `sudo` time stamp until we have finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
dwg ApplePressAndHoldEnabled -bool false 
dwg InitialKeyRepeat -int 10

# Mouse
dwg com.apple.mouse.scaling 5
dwg AppleEnableMouseSwipeNavigateWithScrolls -bool true
dwg MouseButtonMode "TwoButton"
dwg MouseTwoFingerHorizSwipeGesture 2
dwg MouseButtonDivision 55
dwg AppleShowScrollBars "WhenScrolling" 

# Finder
dw com.apple.finder NewWindowTarget -string "PfHm" # New window default location to ~
dw com.apple.frameworks.diskimages skip-verify true
dw com.apple.LaunchServices LSQuarantine -bool false # No "Are you sure you want to open?" msg
dwg NSTableViewDefaultSizeMode -int 1 # smaller sidebar icons
dw com.apple.finder ShowStatusBar -bool true
dw com.apple.finder ShowPathbar -bool true
dw com.apple.finder QLEnableTextSelection -bool true # text selection in quicklook
dw com.apple.desktopservices DSDontWriteNetworkStores -bool true
dw com.apple.finder WarnOnEmptyTrash -bool false
dw com.apple.finder _FXShowPosixPathInTitle -bool true

# default view mode to grid for desktop and list elsewhere
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy list" ~/Library/Preferences/com.apple.finder.plist
chflags nohidden ~/Library # show ~/Library

# Dock and desktop
dw com.apple.finder CreateDesktop false; # no desktop icons
dw com.apple.dock tilesize -int 32
dark-mode off; dark-mode on

# Mission Control
dw com.apple.dock mru-spaces -bool false # don't automatically rearrange spaces

# Dialogs
dwg NSNavPanelExpandedStateForSaveMode -bool true
dwg PMPrintingExpandedStateForPrint -bool true
dwg NSNavPanelExpandedStateForSaveMode2 -bool true
dwg PMPrintingExpandedStateForPrint2 -bool true
dwg NSDocumentSaveNewDocumentsToCloud -bool false

# Locale
dw com.apple.menuextra.clock 'DateFormat' -string 'EEE d  HH:mm'
dwg AppleTemperatureUnit -string "Celsius"
dwg AppleMeasurementUnits -string "Centimeters"
dwg AppleMetricUnits -bool true
dwg AppleLocale -string "en_GB@currency=USD"
dwg AppleLanguages -array "en_GB" "en_US"

# MAS
dw com.apple.SoftwareUpdate AutomaticDownload -int 1
dw com.apple.commerce AutoUpdate -bool true
dw com.apple.commerce AutoUpdateRestartRequired -bool true
dw com.apple.SoftwareUpdate ScheduleFrequency -int 1 # daily updates
dw com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
dw com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Photos
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# TextEdit
dw com.apple.TextEdit RichText -int 0 # default to plain text

# iTerm
dw com.googlecode.iterm2 PromptOnQuit -bool false # no prompt on quit

# Misc
dw com.apple.print.PrintingPrefs "Quit When Finished" -bool true
dw com.apple.LaunchServices LSQuarantine -bool false # Disable the “Are you sure you want to open this application?” dialog
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName # Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window

# Git
git config --global author.name "Rik Brown"
git config --global author.email "rik@rik.codes"

# Power management
sudo pmset autorestart 1
sudo systemsetup -setrestartfreeze on # restart on mac bsod

#
# Terminal
#

echo "Setting Fish as shell"
sudo sh -c "grep -q -F fish /etc/shells || echo /usr/local/bin/fish >> /etc/shells"
sudo chsh -s /usr/local/bin/fish $USER

#
# Dock
#

if [ ! $IS_SETUP ]; then
	# New setup - wipe dock
	dw com.apple.dock persistent-apps -array
fi

#
# Setup cron scripts
#
echo "Setting up cron scripts"

# Copy and update scripts
mkdir -p ~/bin/mac-configuration
cp -r bin/* ~/bin/mac-configuration
sed -i '' "s/SECRETPASSWORD/$PASSWORD/g" ~/bin/mac-configuration/cron-scripts/upgrade-brews.sh # Set password in upgrade-brews

# Setup crontab to run at 3:30am
(crontab -l 2>/dev/null | grep -q MAILTO) || (echo 'MAILTO="rik@rikbrown.co.uk"'; crontab -l 2>/dev/null) | crontab - 
(crontab -l 2>/dev/null | grep -q run-cron-scripts) || (crontab -l 2>/dev/null; echo '30 3 * * * ~/bin/mac-configuration/cron-scripts/run-cron-scripts.sh --sleep') | crontab -

# Wake up to run it at 3:29am
sudo pmset repeat wakeorpoweron MTWRFSU 03:29:00

# Enable cron logging
(grep -q cron /etc/syslog.conf) || sudo tee -a /etc/syslog.conf > /dev/null << EOF
cron.* /var/log/cron.log
EOF

#
# Cleanup
#

echo "Cleaning up"
dw codes.rik.macconfig IsSetup -bool true

# Reset finder
echo "Killing your favourite processes"
killall Finder
killall Dock
killall SystemUIServer

# 
# Open relevant installed apps so we can do things with them
#
if [ ! $IS_SETUP ]; then
	echo "Opening apps"
	open "/Applications/Alfred 3.app"
	open /Applications/BetterSnapTool.app
	open /Applications/Dropbox.app
	open "/Applications/Backup and Sync.app"
fi
