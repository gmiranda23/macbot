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

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo
headline "                           "
headline " Let's secure your Mac and install basic applications. "
headline "                           "


echo
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
echo "Enable bash autocomplete"
run sudo cp ./files/inputrc ~/.inputrc


echo
chapter "Making UX and performance improvements."

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

echo "Disable Safari from auto-filling sensitive data."
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillCreditCardData -bool false
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillFromAddressBook -bool false
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillMiscellaneousForms -bool false
run defaults write ~/Library/Preferences/com.apple.Safari AutoFillPasswords -bool false

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

echo "Set all network interfaces to use Cloudflare DNS (1.1.1.2 - malware blocking)."
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

# Note: Before installing Homebrew, set the following for increased privacy.
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

echo "Install Homebrew."
which -s brew
if [[ $? != 0 ]] ; then
    run '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
else
    run brew update
fi

echo "Install brew taps."
run brew tap "homebrew/core"
run brew tap "homebrew/bundle"
run brew tap "homebrew/cask"
run brew tap "homebrew/cask-fonts"

echo "Installing a modern BASH and making that a valid shell."
run brew install bash
run brew upgrade bash
run sudo -s 'echo "/usr/local/bin/bash" >> /etc/shells'
# To set BASH as your shell, uncomment this line
#run chsh -s /usr/local/bin/bash

echo "Install and configure git."
run brew install git
run brew upgrade git
run git config --global user.email "george.miranda@gmail.com"
run git config --global user.name "gmiranda23"


# List of all brew packages to install
brewcli="fd fzf jq mas ripgrep thefuck speedtest-cli wget youtube-dl ffmpeg"

for i in $brewcli ; do
  echo "Install $i"
  run brew install $i
  run brew upgrade $i
done


echo
chapter "Install basic apps from brew cask"

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
mac_app_login=$(mas account | grep @)
if [ -z "$mac_app_login" ] ; then
    echo "To install Mac App Store applications, you must be logged in. What is your Mac App Store email login? $bold"
    read mac_app_login
    run mas signin $mac_app_login
fi

echo "Install 1Password 7."
run mas install 1333542190

#echo "Install Activity Timer."
#run mas install 808647808

echo "Install Keynote."
run mas install 409183694

echo "Install Slack."
run mas install 803453959

echo "Install Speedtest."
run mas install 1153157709

echo "Install Things3."
run mas install 904280696

echo "Install Tweetdeck."
run mas install 485812721

echo "Install Xcode."
run mas install 497799835

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


headline "Some settings will not take effect until you restart your computer."
echo
headline "               "
headline " Your Mac is set up and ready! "
headline "               "
echo
