<<<<<<< HEAD
#!/usr/local/bin/bash

#---------------#
# Color palette #
#---------------#
reset=$(tput sgr0)
bold=$(tput bold)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
highlight1=$(echo -e "setaf 7\nsetab 1" | tput -S)	# set fg white & bg red
highlight2=$(echo -e "setaf 7\nsetab 2" | tput -S)	# set fg white & bg green

#-------------------#
# Logging functions #
#-------------------#
headline() {
  printf "${highlight1} %s ${reset}\n" "$@"
}

chapter() {
  echo "${highlight2} $((count++)).) $@ ${reset}"
  echo
}

# Prints out a step, if last parameter is true then without an ending newline
step() {
  if [ $# -eq 1 ]
    then echo "${yellow}▸ ${reset}$@"
    else echo "${yellow}▸ ${reset}$@"
  fi
}

# Prints out commands, then runs then
run() {
  echo "  ${green}▹ $@ $reset"
  eval $@
}

#------#
# Init #
#------#
user=$(id -un)						# current user
=======
#!/usr/bin/env bash

source "./public.bash"

# Current User
user=$(id -un)
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

<<<<<<< HEAD
echo
headline "                           "
headline " Let's secure your Mac and install basic applications. "
headline "                           "


echo
chapter "Modifying settings for user: $user."

step "Closing any open System Preferences panes, to prevent them from overriding settings we’re about to change."
run osascript -e 'tell application "System Preferences" to quit'
=======
echo ""
headline " Let's secure your Mac and install basic applications."
echo ""
echo "Modifying settings for user: $user."
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af

# Ask for the administrator password upfront
if [ $(sudo -n uptime 2>&1|grep "load"|wc -l) -eq 0 ]
then
  step "Some of these settings are system-wide, therefore we need your permission."
  sudo -v
  echo
fi

step "Setting your computer name (as done via System Preferences → Sharing)."
echo "What would you like it to be? $bold"
read computer_name
echo "$reset"
run sudo scutil --set ComputerName "'$computer_name'"
run sudo scutil --set HostName "'$computer_name'"
run sudo scutil --set LocalHostName "'$computer_name'"
run sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "'$computer_name'"

# Files
echo "Enable bash autocomplete"
run sudo cp ./files/inputrc ~/.inputrc


echo
chapter "Making UX and performance improvements."

<<<<<<< HEAD
=======
echo "Disable startup chime sound."
run sudo nvram SystemAudioVolume=" "

# UX And Performance Improvements
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af
echo "Disable sudden motion sensor. (Not useful for SSDs)."
run sudo pmset -a sms 0

echo "Use 24-hour time. Use the format EEE MMM d  H:mm:ss"
run defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  H:mm:ss'

echo "Set a fast keyboard repeat rate, after a good initial delay."
run defaults write NSGlobalDomain KeyRepeat -int 1
run defaults write NSGlobalDomain InitialKeyRepeat -int 25

echo "Disable auto-correct."
run defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "Speed up mission control animations."
run defaults write com.apple.dock expose-animation-duration -float 0.1

echo "Remove the auto-hiding dock delay."
run defaults write com.apple.dock autohide-delay -int 0

echo "Save screenshots in PNG format."
run defaults write com.apple.screencapture type -string png

echo "Save screenshots to user screenshots directory instead of desktop."
run mkdir ~/Screenshots
run defaults write com.apple.screencapture location -string ~/Screenshots

echo "Disable shadow in screenshots."
defaults write com.apple.screencapture disable-shadow -bool true

echo "Disable menu transparency."
run defaults write com.apple.universalaccess reduceTransparency -int 1

echo "Disable mouse enlargement with jiggle."
run defaults write ~/Library/Preferences/.GlobalPreferences CGDisableCursorLocationMagnification -bool true

echo "Disable annoying UI error sounds."
run defaults write com.apple.systemsound com.apple.sound.beep.volume -int 0
run defaults write com.apple.sound.beep feedback -int 0
run defaults write com.apple.systemsound com.apple.sound.uiaudio.enabled -int 0
run osascript -e 'set volume alert volume 0'

echo "Show all filename extensions."
run defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Disable the warning when changing a file extension."
run defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Use list view in all Finder windows by default."
run defaults write com.apple.finder FXPreferredViewStyle -string '"Nlsv"'

echo "Show the ~/Library folder."
run chflags nohidden ~/Library

echo "Show the /Volumes folder."
run sudo chflags nohidden /Volumes

echo "Show hidden files (whose name starts with dot) in finder."
run defaults write com.apple.finder AppleShowAllFiles -int 1

echo "Show full file path in finder windows."
run defaults write _FXShowPosixPathInTitle com.apple.finder -int 1

echo "Don't write DS_Store files to network shares."
run defaults write DSDontWriteNetworkStores com.apple.desktopservices -int 1

echo "Don't ask to use external drives as a Time Machine backup."
run defaults write DoNotOfferNewDisksForBackup com.apple.TimeMachine -int 1

echo "Use the dark theme."
run defaults write ~/Library/Preferences/.GlobalPreferences AppleInterfaceStyle -string "Dark"


echo
chapter "Making security and privacy improvements."

<<<<<<< HEAD
=======
echo "Always show scrollbars."
run defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "Expand save panel by default."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Expand print panel by default."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Disable automatic capitalization."
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "Disable smart dashes."
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "Disable automate period substitution."
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "Disable smart quotes."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "Enable subpixel font rendering on non-Apple LCDs."
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Security And Privacy Improvements
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af
echo "Disable Safari from auto-filling sensitive data."
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillCreditCardData -bool false
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillFromAddressBook -bool false
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillMiscellaneousForms -bool false
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillPasswords -bool false

echo "Enable Do Not Track in Safari."
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo "Disable Safari from automatically opening files."
run defaults write ~/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false

echo "Enable Safari warnings when visiting fradulent websites."
run defaults write ~/Library/Preferences/com.apple.Safari WarnAboutFraudulentWebsites -bool true

echo "Block popups in Safari."
run defaults write ~/Library/Preferences/com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
run defaults write ~/Library/Preferences/com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false

#echo "Always block cookies and local storage in Safari."
#run defaults write ~/Library/Preferences/com.apple.Safari BlockStoragePolicy -bool false

#echo "Disable javascript in Safari."
#run defaults write ~/Library/Preferences/com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptEnabled -bool false
#run defaults write ~/Library/Preferences/com.apple.Safari WebKitJavaScriptEnabled -bool false

#echo "Disable plugins and extensions in Safari."
#run defaults write ~/Library/Preferences/com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2WebGLEnabled -bool false
#run defaults write ~/Library/Preferences/com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false
#run defaults write ~/Library/Preferences/com.apple.Safari WebKitPluginsEnabled -bool false
#run defaults write ~/Library/Preferences/com.apple.Safari ExtensionsEnabled -bool false
#run defaults write ~/Library/Preferences/com.apple.Safari PlugInFirstVisitPolicy PlugInPolicyBlock
#run defaults write ~/Library/Preferences/com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
#run defaults write ~/Library/Preferences/com.apple.Safari WebKitJavaEnabled -bool false

echo "Safari should treat SHA-1 certificates as insecure."
run defaults write ~/Library/Preferences/com.apple.Safari TreatSHA1CertificatesAsInsecure -bool true

echo "Disable pre-loading websites with high search rankings."
run defaults write ~/Library/Preferences/com.apple.Safari PreloadTopHit -bool false

echo "Disable Safari search engine suggestions."
run defaults write ~/Library/Preferences/com.apple.Safari SuppressSearchSuggestions -bool true

echo "Enable Do-Not-Track HTTP header in Safari."
run defaults write ~/Library/Preferences/com.apple.Safari SendDoNotTrackHTTPHeader -bool true

#echo "Disable pdf viewing in Safari."
#run defaults write ~/Library/Preferences/com.apple.Safari WebKitOmitPDFSupport -bool true

echo "Display full website addresses in Safari."
run defaults write ~/Library/Preferences/com.apple.Safari ShowFullURLInSmartSearchField -bool true


echo "Disable spotlight universal search (don't send info to Apple)."
run defaults write com.apple.safari UniversalSearchEnabled -int 0

echo "Disable Spotlight Suggestions, Bing Web Search, and other leaky data."
run python ./fix_leaky_data.py

echo "Disable Captive Portal Hijacking Attack."
run defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

echo "Set screen to lock almost as soon as the screensaver starts."
run defaults write com.apple.screensaver askForPassword -int 1
run defaults write com.apple.screensaver askForPasswordDelay -int 5

echo "Don't default to saving documents to iCloud."
run defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Disable crash reporter."
run defaults write com.apple.CrashReporter DialogType none

echo "Enable Stealth Mode. Computer will not respond to ICMP ping requests or connection attempts from a closed TCP/UDP port."
run defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true

<<<<<<< HEAD
echo "Set all network interfaces to use Cloudflare DNS (1.1.1.2 - malware blocking)."
=======
echo "Enable AirDrop over Ethernet."
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "Set all network interfaces to use Cloudflare DNS (1.1.1.1)."
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af
run bash ./use_cloudflare_dns.sh

echo "Disable wake on network access."
run systemsetup -setwakeonnetworkaccess off

#echo "Disable Bonjour multicast advertisements."
#run defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

# This is disabled by default, but sometimes people turn it on and forget to turn it back off again.
echo "Turn off remote desktop access."
run sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off

echo "Enable Mac App Store automatic updates."
run defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

#echo "Check for Mac App Store updates daily."
#run defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

#echo "Download Mac App Store updates in the background."
#run defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo "Install Mac App Store system data files & security updates."
run defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

#echo "Turn on Mac App Store auto-update."
#run defaults write com.apple.commerce AutoUpdate -bool true


echo
chapter "Install CLI applications with homebrew"

<<<<<<< HEAD
# Note: Before installing Homebrew, set the following for increased privacy.
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
=======
# Download Packaged Software
# Some software comes packaged directly from the vendor
# Eventually we'll automate the installs of each of these
# But the biggest challenege is just remembering
# Which apps you need to download, so let's do that for now

download_file "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US" "firefox-latest.dmg"

download_file "https://app-updates.agilebits.com/download/OPM7" "1password-latest.pkg"

download_file "https://iterm2.com/downloads/stable/iTerm2-3_2_9.zip" "iTerm2-3_2_9.zip"

download_file "https://discordapp.com/api/download?platform=osx" "discord-latest.dmg"

download_file "https://dl.iina.io/IINA.v1.0.4.dmg" "IINA.v1.0.4.dmg"

download_file "https://cdn-fastly.obsproject.com/downloads/obs-mac-23.2.1-installer.pkg" "obs-mac-23.2.1-installer.pkg"

download_file "https://www.kaleidoscopeapp.com/download" "kaleidoscope-latest.zip"

download_file "https://github.com/transmission/transmission-releases/raw/master/Transmission-2.94.dmg" "Transmission-2.94.dmg"

download_file "https://d2oxtzozd38ts8.cloudfront.net/audiohijack/download/AudioHijack.zip" "AudioHijack.zip"

download_file "https://github.com/pje/WavTap/releases/download/0.3.0/WavTap.0.3.0.pkg" "WavTap.0.3.0.pkg"

download_file "https://central.github.com/deployments/desktop/desktop/latest/darwin" "github-latest.dmg"

download_file "https://steamcdn-a.akamaihd.net/client/installer/steam.dmg" "steam-latest.dmg"

download_file "https://updates.signal.org/desktop/signal-desktop-mac-1.25.3.zip" "signal-desktop-mac-1.25.3.zip"

# Blackmagic uses expiring keys to force you through their registration dialog
# *sigh* Manual download for now I guess... https://sw.blackmagicdesign.com/DesktopVideo/v11.2/Blackmagic_Desktop_Video_Macintosh_11.2.zip

# Install Applications
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af

echo "Install Homebrew."
which -s brew
if [[ $? != 0 ]] ; then
    run '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
else
    run brew update
fi

<<<<<<< HEAD
echo "Install brew taps."
run brew tap "homebrew/core"
run brew tap "homebrew/bundle"
run brew tap "homebrew/cask"
run brew tap "homebrew/cask-fonts"
=======
echo "Install and configure git."
run brew install git
run git config --global user.email "echohack@users.noreply.github.com"
git config --global user.name "echohack"

echo "Prevent iTunes from taking backups of iPhone."
run defaults write com.apple.iTunes DeviceBackupsDisabled -bool true

echo "Install jq."
run brew install jq

echo "Install tldr."
run brew install tldr
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af

echo "Installing a modern BASH and making that a valid shell."
run brew install bash
run brew upgrade bash
run sudo 'echo "/usr/local/bin/bash" >> /etc/shells'
# To set BASH as your shell, uncomment this line
#run chsh -s /usr/local/bin/bash

<<<<<<< HEAD
echo "Install and configure git."
run brew install git
run brew upgrade git
run git config --global user.email "george.miranda@gmail.com"
run git config --global user.name "gmiranda23"

=======
echo "Prevent Google Chrome from Syncing automatically."
run defaults write com.google.Chrome SyncDisabled -bool true
run defaults write com.google.Chrome RestrictSigninToPattern -string ".*@example.com"

echo "Install Shadowfox (dark theme for Firefox)."
run brew install srkomodo/tap/shadowfox-updater
# This requires some gui interaction and firefox pre-installed...
# shadowfox-updater -generate-uuids -profile-index 0 -set-dark-theme

echo "Install youtube-dl."
run brew install youtube-dl
run brew upgrade youtube-dl
run brew install ffmpeg
run brew upgrade ffmpeg

echo "Install keyboard flashing tool for Nightfox Mechanical keyboard."
run brew install dfu-util
# Flash with dfu-util -a 0 -R -D kiibohd.dfu.bin

echo "Install exercism CLI."
run brew install exercism
run brew upgrade exercism

echo "Install shellcheck."
run brew install shellcheck

echo "Install pre-commit"
run brew install pre-commit
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af

# List of all brew packages to install
brewcli="fd fzf jq mas ripgrep thefuck speedtest-cli wget youtube-dl ffmpeg"

for i in $brewcli ; do
  echo "Install $i"
  run brew install $i
  run brew upgrade $i
done


echo
chapter "Install basic apps from brew cask"

<<<<<<< HEAD
# List of all brew cask apps
brewcasks="atom audacity caffeine choosy dropbox firefox flux font-hack-nerd-font font-inconsolata-for-powerline
           google-chrome iterm2 krisp macvim menumeters moom paintbrush screenflow skype spotify timer vlc zoomus"

for ii in $brewcasks ; do
  echo "Install $ii"
  run brew cask install $ii
done


echo
chapter "Install Mac App Store applications (using mas-cli - https://github.com/mas-cli/mas)."

# New for Catalina: you must already be logged into the app store for this to work
=======
echo "Install Visual Studio Code Extensions."
vscode_install_ext(){
    run code --install-extension $@
}
vscode_install_ext bungcip.better-toml
vscode_install_ext mauve.terraform
vscode_install_ext ms-python.python
vscode_install_ext ms-vscode.vscode-typescript-tslint-plugin
vscode_install_ext redhat.vscode-yaml
vscode_install_ext rust-lang.rust

echo "Install npm."
run brew install npm

# Trust a curl | bash? Why not.
echo "Install rust using Rustup."
rustc --version
if [[ $? != 0 ]] ; then
    run curl https://sh.rustup.rs -sSf | sh
    run rustup update
fi

# Install all the Mac App Store applications using mas. https://github.com/mas-cli/mas
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af
mac_app_login=$(mas account | grep @)
if [ -z "$mac_app_login" ] ; then
    echo "To install Mac App Store applications, you must be logged in. What is your Mac App Store email login? $bold"
    read mac_app_login
    run mas signin $mac_app_login
fi

<<<<<<< HEAD
echo "Install 1Password 7."
run mas install 1333542190

#echo "Install Activity Timer."
#run mas install 808647808
=======
echo "Install Decompressor."
run mas install 1033480833

echo "Install Divvy."
run mas install 413857545

echo "Install DrawnStrips Reader."
run mas install 473092872

echo "Install HEIC Converter."
run mas install 1294126402
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af

echo "Install Keynote."
run mas install 409183694

<<<<<<< HEAD
=======
echo "Install Microsoft Remote Desktop."
run mas install 1295203466

echo "Install Pixelmator Pro."
run mas install 1289583905

echo "Install Reeder."
run mas install 880001334

>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af
echo "Install Slack."
run mas install 803453959

echo "Install Speedtest."
run mas install 1153157709

echo "Install Things3."
run mas install 904280696

echo "Install Tweetdeck."
run mas install 485812721

<<<<<<< HEAD
echo "Install Webcam Settings"
run mas install 533696630

echo "Install Xcode."
run mas install 497799835

=======
# Transmission.app

echo "Transmisson: Don’t prompt for confirmation before downloading."
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

echo "Transmisson: Don’t prompt for confirmation before removing non-downloading active transfers."
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

echo "Transmisson: Trash original torrent files."
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo "Transmisson: Hide the donate message."
defaults write org.m0k.transmission WarningDonate -bool false
echo "Transmisson: Hide the legal disclaimer."
defaults write org.m0k.transmission WarningLegal -bool false

echo "Transmisson: IP block list."
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

echo "Transmisson: Randomize port on launch."
defaults write org.m0k.transmission RandomPort -bool true

# Final updates
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af
echo "Upgrade any Mac App Store applications."
run mas upgrade


echo
chapter "Final updates and restarts."

echo "Run one final check to make sure software is up to date."
run softwareupdate -i -a

echo "Restart System Services."
run killall Dock
run killall Finder
run killall SystemUIServer

<<<<<<< HEAD

headline "Some settings will not take effect until you restart your computer."
echo
headline "               "
headline " Your Mac is set up and ready! "
headline "               "
echo
=======
chapter "Some settings will not take effect until you restart your computer."
headline " Your Mac is setup and ready!"


#https://itunes.apple.com/us/app/pixelmator-pro/id1289583905?mt=12
>>>>>>> b6cea64a3b3282d30a1df42a2c2b4b401b54b9af
