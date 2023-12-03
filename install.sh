#!/usr/bin/env bash

source "./public.bash"

# Current User
user=$(id -un)

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo
headline "                           "
headline " Let's secure your Mac and install basic applications. "
headline "                           "
echo

#---------------#
# User Settings #
#---------------#
chapter "Modifying settings for user: $user."

step "Closing any open System Preferences panes, to prevent them from overriding settings we’re about to change."
run osascript -e 'tell application "System Preferences" to quit'

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
echo "Set bash autocomplete & preferences"
run sudo cp ./files/inputrc ~/.inputrc

#-----------------#
# UX Improvements #
#-----------------#
echo
chapter "Making UX and performance improvements."

#echo "Disable startup chime sound."
#run sudo nvram SystemAudioVolume=" "

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

#echo "Disable annoying UI error sounds."
#run defaults write com.apple.systemsound com.apple.sound.beep.volume -int 0
#run defaults write com.apple.sound.beep feedback -int 0
#run defaults write com.apple.systemsound com.apple.sound.uiaudio.enabled -int 0
#run osascript -e 'set volume alert volume 0'

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

echo "Always show scrollbars."
run defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "Expand save panel by default."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Expand print panel by default."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

#echo "Disable automatic capitalization."
#defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
#
#echo "Disable smart dashes."
#defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "Disable automate period substitution."
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "Disable smart quotes."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

#echo "Enable subpixel font rendering on non-Apple LCDs."
## Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
#defaults write NSGlobalDomain AppleFontSmoothing -int 1

echo "Use the dark theme."
run defaults write ~/Library/Preferences/.GlobalPreferences AppleInterfaceStyle -string "Dark"

#--------------------#
# Security & Privacy #
#--------------------#
echo
chapter "Making security and privacy improvements."

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

#echo "Don't default to saving documents to iCloud."
#run defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Disable crash reporter."
run defaults write com.apple.CrashReporter DialogType none

echo "Enable Stealth Mode. Computer will not respond to ICMP ping requests or connection attempts from a closed TCP/UDP port."
run defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true

echo "Enable AirDrop over Ethernet."
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

#echo "Set all network interfaces to use Cloudflare DNS (1.1.1.1)."
#run bash ./use_cloudflare_dns.sh

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

echo "Turn on Mac App Store auto-update."
run defaults write com.apple.commerce AutoUpdate -bool true

# Blocklists
#echo "Block all Facebook domains."
#if ! grep --quiet facebook /etc/hosts; then
#    run cat block_facebook | sudo tee -a /etc/hosts
#else
#    echo "${dim}▹ Facebook domains already blocked. $reset"
#fi

#-------------------#
# Download software #
#-------------------#
# Eventually we'll automate the installs of each of these, or they're older
# The biggest challenege is just remembering which apps you need 
echo
chapter "Downloading some software for manual installation later."

download_file "https://central.github.com/deployments/desktop/desktop/latest/darwin" "github-latest.dmg"
download_file "https://updates.signal.org/desktop/signal-desktop-mac-1.25.3.zip" "signal-desktop-mac-1.25.3.zip"
download_file "https://www.telestream.net/download-files/screenflow/9-0/ScreenFlow-9.0.8.dmg" "ScreenFlow-9.0.8.dmg"

#-----------------------#
# Brew install software #
#-----------------------#
echo
chapter "Installing CLI applications with homebrew"

# Note: Before installing Homebrew, set the following in your .bash_profile for increased privacy.
#export HOMEBREW_NO_ANALYTICS=1
#export HOMEBREW_NO_INSECURE_REDIRECT=1

echo "Install Homebrew."
which -s brew
if [[ $? != 0 ]] ; then
    run '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
else
    run brew update
fi

echo "Install and configure git."
run brew install git
run brew upgrade git
run git config --global user.email "george.miranda@gmail.com"
run git config --global user.name "gmiranda23"

#-------------------------------------
# List of all brew packages to install
#-------------------------------------
# jq - A lightweight and flexible command-line JSON processor
# wget - Internet file retriever
# node - nodeJS (to get npm)
# shellcheck - Static analysis and lint tool, for (ba)sh scripts
# tldr - Simplified and community-driven man pages
# speedtest-cli - Command-line interface for https://speedtest.net bandwidth tests
# ffmpeg - Play, record, convert, and stream audio and video
# youtube-dl - Download YouTube videos from the command-line (deprecated, but still handy)
# yt-dlp - Fork of youtube-dl with additional features and fixes
# mas - Mac App Store command-line interface

brewcli="
  jq
  wget
  node
  shellcheck
  tldr
  speedtest-cli
  ffmpeg
  youtube-dl
  yt-dlp
  mas
"
for i in $brewcli ; do
  echo "Install $i"
  run brew install $i
  run brew upgrade $i
done

#----------------------------------
# List of all brew casks to install
#----------------------------------
# atom - GitHub Atom Editor (discontinued upstream)
# audacity - Multi-track audio editor and recorder
# choosy - Open links in any browser
# dropbox - Client for the Dropbox cloud storage service
# iterm2 - Terminal emulator as alternative to Apple's Terminal app
# menumeters - Set of CPU, memory, disk, and network monitoring tools
# moom - Utility to move and zoom windows—on one display
# paintbrush - Simple MacOS image editor
# skype - Video chat, voice call and instant messaging application
# spotify - Music streaming service
# timer - Stopwatch, alarm clock, and clock utility
# vlc - Multimedia player
# visual-studio-code -  Microsoft Visual Studio Code, open-source code editor
# zoom - Video communication and virtual meeting platform
# firefox - Mozilla Firefox web browser
# google-chrome - Google Chrome web browser

brewcasks="atom audacity choosy dropbox iterm2 menumeters moom paintbrush skype spotify timer
vlc visual-studio-code zoom firefox google-chrome"

for ii in $brewcasks ; do
  echo "Install $ii"
  run brew install --cask $ii
done

#------------------------------#
# Configure installed software #
#------------------------------#
echo
chapter "Configuring homebrew installed software"

#echo "Install Visual Studio Code Extensions."
#vscode_install_ext(){
#  run code --install-extension $@
#}
#vscode_install_ext ms-python.python
#vscode_install_ext rust-lang.rust

echo "Prevent Google Chrome from Syncing automatically."
run defaults write com.google.Chrome SyncDisabled -bool true
run defaults write com.google.Chrome RestrictSigninToPattern -string ".*@example.com"

#echo "Install Shadowfox (dark theme for Firefox)."
#run brew install srkomodo/tap/shadowfox-updater
# This requires some gui interaction and firefox pre-installed...
# shadowfox-updater -generate-uuids -profile-index 0 -set-dark-theme

#----------------------------------#
# Configure Mac App Store software #
#----------------------------------#
# Install all the Mac App Store applications using mas. https://github.com/mas-cli/mas
echo
chapter "Installing Mac App Store applications."

mac_app_login=$(mas account | grep @)
if [ -z "$mac_app_login" ] ; then
  chapter "What is your Mac App Store email login? $bold"
  read mac_app_login
  run mas signin $mac_app_login
fi

#--------------------------------------
# List of all mas apps to install
# format: ["pkg_id"]="Descriptive name"
# (use 'mas search' to maintain)
#--------------------------------------
declare -A mas_array=(
  ["1333542190"]="1Password 7"
  ["808647808"]="Activity Timer"
  ["409183694"]="Keynote"
  ["803453959"]="Slack"
  ["1153157709"]="Speedtest by Ookla"
  ["533696630"]="Webcam Settings"
  ["497799835"]="Xcode"
)

for key in ${!mas_array[@]}
do
  echo "Install ${mas_array[${key}]}"
  run mas install ${key}
done

# App store updates
echo "Upgrade any Mac App Store applications."
run mas upgrade

#---------------#
# Final updates #
#---------------#
echo
chapter "Final updates and restarts."

echo "Run one final check to make sure software is up to date."
run softwareupdate -i -a

echo
headline "                          "
headline " Your Mac is set up and ready!"
headline " Some settings will not take effect until you reboot."
headline "                          "

sec=10; while [ $sec -ge 0 ]; do
  echo -ne "Rebooting in $sec\033[0K\r"
  let "sec=sec-1"
  sleep 1
done

echo "Restart System Services."
run killall Dock
run killall Finder
run killall SystemUIServer
