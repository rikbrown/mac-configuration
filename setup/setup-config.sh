#!/bin/sh
alias dw="defaults write"
alias dwg="defaults write -g"

#
# Defaults
#

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

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

# Disable guest user
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false

# Misc
dw com.apple.print.PrintingPrefs "Quit When Finished" -bool true
dw com.apple.LaunchServices LSQuarantine -bool false # Disable the “Are you sure you want to open this application?” dialog
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName # Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window

#
# Power management
#

sudo pmset autorestart 1
sudo systemsetup -setrestartfreeze on # restart on mac bsod

#
# Terminal
#

echo "Setting Fish as shell"
sudo sh -c "grep -q -F fish /etc/shells || echo /usr/local/bin/fish >> /etc/shells"
sudo chsh -s /usr/local/bin/fish $USER
curl -L https://get.oh-my.fish | fish

