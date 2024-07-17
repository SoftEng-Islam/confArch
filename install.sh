#!/bin/bash
# -------------------------------------------------------
# The CONFARCH Project.
# Arch Linux enhancement configuration
# -------------------------------------------------------
# Warning
# Please don't use this script, still under development
# -------------------------------------------------------

# ----------------------------------------------------
# Check if running as root. If root, script will exit
# ----------------------------------------------------
if [ $EUID -eq 0 ]; then
	echo "This script should not be executed as root! Exiting......."
	exit 1
fi
clear

# -------------------------------------------------------------
# Check if the User want to Install or Improve Hyprland/themes
# -------------------------------------------------------------
if [ "$1" == 'hyprland' ]; then
	# Install Hyprland and Some Deps
fi

# ----------------------------------------------------------
# Check if the User want to Install or Improve Gnome/themes
# ----------------------------------------------------------
if [ "$1" == 'gnome' ]; then
	# Install Gnome and Some Deps
fi

# ------------------------------------
# set colors into vars
# ------------------------------------
# Regular Colors:
RBlack='\033[30m'
RRed='\033[31m'
RGreen='\033[32m'
RYellow='\033[33m'
RBlue='\033[34m'
RMagenta='\033[35m'
RCyan='\033[36m'
RWhite='\033[37m'

# Bright (Bold) Colors:
BrBlack='\033[90m'
BrRed='\033[91m'
BrGreen='\033[92m'
BrYellow='\033[93m'
BrBlue='\033[94m'
BrMagenta='\033[95m'
BrCyan='\033[96m'
BrWhite='\033[97m'

NC='\033[0m'
BOLD='\033[1m'
Italic='\033[3m'
Underline='\033[4m'
Strikethrough='\033[9m'

RESET="\033[0m" # Reset color

# Unicode Characters
# `echo -e "\u2764"   # Outputs a heart symbol (❤)`
heart='\u2764'

# ---------------------------------------------------------------
# Say Hello, and give the user some information about his device
# ---------------------------------------------------------------
echo -e "$(
	cat <<EOF

${RMagenta}===================================================================${RESET}
${RMagenta}= ${RESET} \e[31mWelcome\e[0m \e[1;32m$(whoami)\e[0m
${RMagenta}= ${RESET} Today's date is: \e[93m$(date)\e[0m
${RMagenta}= ${RESET} \e[3;90mfeel free to message me on\e[0m \e[1;34mTwitter\e[0m: \e[4;96mhttps://x.com/SoftEng_Islam\e[0m
${RMagenta}===================================================================${RESET} \n

EOF
)"
# -----------------------------------------------
# Options for User
# -----------------------------------------------
echo 'Select your Options:'
# Install Or Improve Gnome
# Install Or Improve Hyprland
# Install Themes & Icons
# Install Apps And Useful Packages
# Install Fonts
# Install Drivers
# Install Tools & Languages for Developers
# Install Wine To Run Windows apps and games
# Install ZSH & OH-MY-ZSH
# Install Pomodoro
# Install plymouth-themes

# ---------------------
# Update the Packages
# ---------------------
cd ~/Downloads/
echo 'Update the Packages'
# sudo -i
sudo rm /var/lib/pacman/db.lck
sudo pacman -Scc --noconfirm
sudo pacman -Syu --noconfirm && sudo pacman -Sc --noconfirm && yay -Syu --noconfirm --devel
sudo pacman -S --noconfirm linux-firmware
sudo mkinitcpio -P

# -----------------
# Install Packages
# -----------------
echo 'Install Needed Packages'
echo 'Install yay'
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# echo 'Install debtap by yay'
# yay -S debtap
# echo 'Initialize `debtap` (only needed the first time)'
# debtap -u

# Microsoft Partition FileSystem Format 'NTFS'
echo 'Install ntfs-3g to Support MS partition file system'
pacman -Sy --noconfirm ntfs-3g
modprobe fuse

# Install ZSH & oh-my-zsh
sudo pacman -S --noconfirm zsh fzf
chsh -s /bin/zsh

# Kitty terminal emulator
echo 'Install Kitty terminal emulator'
sudo pacman -S --noconfirm kitty
echo 'Set Kitty as the Default Terminal:'
export TERMINAL=kitty
# Kitty's configuration file can be found at ~/.config/kitty/kitty.conf.
# You can customize Kitty's appearance and behavior by editing this file.

# ######################
# install-OneUI
########################

#####################
# install-bibata
#####################

#########################
# install gnome-pomodoro
#########################
yay -S gnome-pomodoro

echo 'Disable Gnome Check-alive'
gsettings set org.gnome.mutter check-alive-timeout 0

pacman -S flatpak --noconfirm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# increase the timeout settings for Flatpak
FLATPAK_CONF="/etc/flatpak/flatpak.conf"
echo "[Network]"  >> $FLATPAK_CONF
# Increase timeout settings (adjust as needed)
echo "RequestTimeout=800"  >> $FLATPAK_CONF
echo "Timeout settings updated in $FLATPAK_CONF"

#######################
# overclocing
#######################
yay -S corectrl

############
# plymouth
############
sudo pacman -S plymouth
sudo plymouth-set-default-theme -R arch-logo
sudo mkinitcpio -p linux
sudo systemctl daemon-reload
systemctl status plymouth.service
ls /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R details

##########################
# Install ZSH & oh_my_zsh
##########################

################################
# Install Some Gnome Extensions
################################

##########################
# Install Apps
# `flatpak install -y flathub com.visualstudio.code org.mozilla.firefox`
##########################
echo 'Installing Resources App'
flatpak install flathub com.visualstudio.code org.mozilla.firefox
net.nokyan.Resources com.microsoft.Edge com.google.Chrome com.mattjakeman.ExtensionManager org.qbittorrent.qBittorrent com.protonvpn.www com.github.zadam.trilium

# List of Flatpak applications to install (replace with your desired apps)
APPS=(
	# "com.visualstudio.code"
	"org.mozilla.firefox"
	"com.microsoft.Edge"
	"com.google.Chrome"
	"net.nokyan.Resources"
	"com.mattjakeman.ExtensionManager"
	"org.qbittorrent.qBittorrent"
	"com.github.zadam.trilium"
	"org.gnome.Boxes"
	"com.getpostman.Postman"
	"io.dbeaver.DBeaverCommunity"
	"rest.insomnia.Insomnia"
	"com.discordapp.Discord"
	"org.telegram.desktop"
	"org.libreoffice.LibreOffice"
	"org.mozilla.Thunderbird"
	"md.obsidian.Obsidian"
	"org.gimp.GIMP"
	"org.kde.krita"
	"org.kde.kdenlive"
	"org.blender.Blender"
	"com.obsproject.Studio"
	"org.gnome.Chess"
	# Beekeeper Studio
	# insomnia
	# Lunacy - UI/UX and Web Designer Tool
	# Krita
	# blender
	# Add more applications as needed
)
# Function to install Flatpak applications
install_flatpak_apps() {
	for app in "${APPS[@]}"; do
		echo "Installing $app..."
		flatpak install flathub $app -y
		echo "---------------------------------------------"
	done
}
# Main execution
install_flatpak_apps
echo "All Flatpak applications installed successfully."
