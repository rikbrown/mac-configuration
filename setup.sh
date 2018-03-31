#!/bin/sh
IS_SETUP=$(defaults read codes.rik.macconfig IsSetup 2>/dev/null)
USER=$(whoami)

#
# Initial prep
#

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

# Install brews/gems from bundles
echo "Unbundling things!"
brew bundle
bundle install

#
# Restore app settings
#
echo "Restoring preferences"
bin/preferences/restore-preferences.rb -l preferences/

#
# Config
#
echo "Configuring system"
setup/setup-config.sh

# Git
git config --global author.name "Rik Brown"
git config --global author.email "rik@rik.codes"

#
# Dock
#

dark-mode off; dark-mode on

if [ ! $IS_SETUP ]; then
	# New setup - wipe dock
	defaults write com.apple.dock persistent-apps -array
fi

#
# Setup cron scripts
#
echo "Setting up cron scripts"

# Copy and update scripts
mkdir -p ~/bin/mac-configuration
chmod 700 ~/bin
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
defaults write codes.rik.macconfig IsSetup -bool true

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
