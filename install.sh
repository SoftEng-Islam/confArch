#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
# ------------------------------------------------------ #
#* The CONFARCH Project.                                 #
#* Arch Linux enhancement configuration                  #
#! --------------------- Warning ----------------------- #
#? Please don't use this script, still under development #
# ------------------------------------------------------ #
# Table of Content #
# ---------------- #
# 1. Declare Variables.
# ____ relative Path
# ____ Colors
# ____ text format
# 2. Import Global Functions.
# ____ prevent_sudo_or_root
# ____ welcome message
# ____ update_packages
# 3. Show Welcome Message.
# 4. Configurations.
# 5. Functions.
# 6. Install Applications & Tools.
# ------------------------------------------------------ #

# -------------------- #
# 1. Declare Variables #
# -------------------- #
# store the relative path into `base` variable
export base && base="$(pwd)"

# Colors #
Black='\033[30m'
Red='\033[31m'
Green='\033[32m'
Yellow='\033[33m'
Blue='\033[34m'
Magenta='\033[35m'
Cyan='\033[36m'
White='\033[37m'
# Bright (Bold) Colors:
B_Black='\033[90m'
B_Red='\033[91m'
B_Green='\033[92m'
B_Yellow='\033[93m'
B_Blue='\033[94m'
B_Magenta='\033[95m'
B_Cyan='\033[96m'
B_White='\033[97m'

# text format
NC='\033[0m'
BOLD='\033[1m'
Italic='\033[3m'
Underline='\033[4m'
Strikethrough='\033[9m'
RESET="\033[0m" # Reset color

# Unicode Characters
# `echo -e "\u2764"   # Outputs a heart symbol (❤)`
heart='\u2764'

# Define the XDG base directories using environment variables.
XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# -------------------------- #
# 2. Import Global Functions #
# -------------------------- #
source ./config.conf # Here your configuration file (you can Edit it)
source "$(pwd)"/sources/global_functions.sh

# --------------------------------------------------- #
# Check if running as root. If root, script will exit #
# --------------------------------------------------- #
prevent_sudo_or_root # The whole function exist in global_functions.sh file

# -------------------- #
# Show Welcome Message #
# -------------------- #
function welcome() {
	echo -e "$(
		cat <<EOF
			${B_Magenta}===================================================================${RESET}
			${B_Magenta}1 ${RESET} ${Red}Welcome${RESET} \e[1;32m$(whoami)\e[0m ${heart}
			${B_Magenta}2 ${RESET} Today's date is: ${B_Yellow}$(date)${RESET}
			${B_Magenta}3 ${RESET} \e[3;90mfeel free to message me on\e[0m \e[1;34mTwitter\e[0m: \e[4;96mhttps://x.com/SoftEng_Islam\e[0m
			${B_Magenta}===================================================================${RESET} \n
EOF
	)"
}
# run the Function
welcome

# ---------------------------- #
# Check if pacman is available #
# ---------------------------- #
# check if the pacman package manager is available on the system.
# If pacman is not found, it prints an error message indicating that
# the system is not Arch Linux or an Arch-based distribution,
# and then it exits the script with a status code of 1.
if ! command -v pacman >/dev/null 2>&1; then
	echo -e "\e[31m[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...\e[0m\n"
	exit 1
else
	echo "pacman is found. Continuing with the script..."
fi

# ------------------- #
# Update the Packages #
# ------------------- #
update_packages

# Check if base-devel is installed
if pacman -Q base-devel &>/dev/null; then
	echo "base-devel is already installed."
else
	echo "Install base-devel.........."
	if sudo pacman -S --noconfirm --needed base-devel linux-firmware linux-headers; then
		echo "base-devel has been installed successfully."
	else
		echo "Error: base-devel not found nor cannot be installed."
		echo "Please install base-devel manually before running this script... Exiting"
		exit 1
	fi
fi

# ----------------------------------------------------------
# Here will some Configuration
# ----------------------------------------------------------
# This Command is used to add the current user to additional groups,
# specifically the video and input groups,
# on a Unix-like operating system
# ----------------------------------------------------------
# Explanation of Each Group:
## video: Access to video devices.
## input: Access to input devices like keyboards and mice.
## audio: Access to audio devices.
## network: Permissions to manage network connections.
## wheel: Ability to use sudo for administrative tasks.
## storage: Access to storage devices.
## lp: Manage printers.
## uucp: Access to serial ports and devices connected via serial ports.
sudo usermod -aG video,input,audio,network,wheel,storage,lp,uucp "$(whoami)"

# Disabling Split Lock Mitigate
# In some cases, split lock mitigate can slow down performance in some applications and games.
# You can disable it via sysctl.
sudo sysctl kernel.split_lock_mitigate=0

# Set performance governor
sudo cpupower frequency-set -g performance

# AMD P-State Core Performance Boost
# Enable boost for all cores
echo 1 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/boost

# disable boost for all cores
# echo 0 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/boost

# --------------------------------------
# Declare and set environment variables
# --------------------------------------
export XDG_RUNTIME_DIR
export XDG_CACHE_HOME
export XDG_CONFIG_HOME
export XDG_DATA_HOME
export WLR_VSYNC

XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_RUNTIME_DIR="/run/user/$(id -u)"
WLR_VSYNC=1

# Enable Wayland support for different applications
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	export WAYLAND=1
	export QT_QPA_PLATFORM='wayland;xcb'
	export GDK_BACKEND='wayland,x11'
	export MOZ_DBUS_REMOTE=1
	export MOZ_ENABLE_WAYLAND=1
	export _JAVA_AWT_WM_NONREPARENTING=1
	export BEMENU_BACKEND=wayland
	export CLUTTER_BACKEND=wayland
	export ECORE_EVAS_ENGINE=wayland_egl
	export ELM_ENGINE=wayland_egl
fi

# -------------------------------------------- #
# Microsoft Partition FileSystem Format 'NTFS' #
# -------------------------------------------- #
echo 'Install ntfs and fuse to Support MS Partition File System'
sudo pacman -S --noconfirm fuse3 ntfs-3g
sudo modprobe fuse
echo 'ntfs and fuse has been installed'
# use lsblk to get information about your disk
# change [partition] to your partition name like: /mnt/Data
# add this line to /etc/fstab
# /dev/disk/by-partlabel/[partition] /mnt/[partition] auto auto,nofail,nodev,uid=1000,gid=1000,utf8,umask=022,exec,x-gvfs-show 0 0

# --------------------------------- #
# Install Git and set Configuration #
# --------------------------------- #
i_git() { # git
	sudo pacman -S --noconfirm git
	# Set git configurations
	git 'config' --global core.autocrlf false
	git 'config' --global core.compression 9
	git 'config' --global http.postBuffer 924288000
	git 'config' --global http.lowSpeedLimit 0
	git 'config' --global http.lowSpeedTime 999999
	git 'config' --global submodule.fetchJobs 4
	git 'config' --global core.packedGitWindowSize 128m
	git 'config' --global core.packedGitLimit 512m
	git 'config' --global advice.addIgnoredFile false
}

# ------------------------------
# Disable Gnome Check-alive
# ------------------------------
echo 'Disable Gnome Check-alive'
gsettings set org.gnome.mutter check-alive-timeout 0

# -------------------------- #
# Install GTK themes & icons #
# -------------------------- #
# Cursor Icons
# System & apps Icons
# GTK Themes
git clone https://github.com/JaKooLit/GTK-themes-icons.git --depth 1
cd GTK-themes-icons || exit
chmod +x auto-extract.sh
./auto-extract.sh

# ------------------ #
# set plymouth theme #
# ------------------ #
set_playmouth_theme() {
	sudo pacman -S plymouth
	sudo plymouth-set-default-theme -R arch-logo
	sudo mkinitcpio -p linux
	sudo systemctl daemon-reload
	systemctl status plymouth.service
	ls /usr/share/plymouth/themes/
	sudo plymouth-set-default-theme -R details
}

# -------------------------------------------------------
# Nautilus backspace
# Extensions for returning back to Nautilus by pressing the combination of keys assigned via Gsettings
# -------------------------------------------------------
i_nautilus_backspace() {
	sudo pacman -Sy python-nautilus
	git clone https://github.com/SoftEng-Islam/nautilus-backspace.git
	cd nautilus-backspace || exit
	sudo make
	sudo make schemas
}

# ----------------------------- #
# Install Arch Package Managers #
# ----------------------------- #
# Check if yay is installed and install it if not
# Yay (Yet Another Yaourt)
# Yay is an AUR helper written in Go, designed to interact with both the official Arch repositories and the AUR (Arch User Repository).
i_yay() {
	if ! command -v yay &>/dev/null; then
		echo "yay is not installed. Installing yay..."
		# Install yay
		sudo pacman -S --needed base-devel git
		# Clone the yay repository from the AUR
		git clone https://aur.archlinux.org/yay.git && cd yay || exit
		# Build and install yay & Change back to the previous directory
		makepkg -si && cd ..
		# Remove the yay directory
		rm -rf yay
		echo "yay has been successfully installed."
	else
		echo "yay is already installed. Continuing with the script..."
	fi
}
# --------------------------------------------------------------------------
# Pikaur
# Pikaur is another AUR helper that’s known for its simplicity and speed.
# --------------------------------------------------------------------------
i_pikaur() {
	# Clone the pikaur repository from the AUR
	git clone https://aur.archlinux.org/pikaur.git
	# Navigate into the pikaur directory
	cd pikaur || exit
	# Build and install pikaur
	makepkg -si
}
# --------------------------------------------------------------------------
# Paru
# Paru is another popular AUR helper that’s similar to Yay but written in Rust.
# --------------------------------------------------------------------------
i_paru() { # paru
	git clone https://aur.archlinux.org/paru.git
	cd paru || exit
	makepkg -si
}
# --------------------------------------------------------------------------
# Trizen
# Trizen is an AUR helper written in Perl and has a similar syntax to Pacman.
# --------------------------------------------------------------------------
i_trizen() {
	# Clone the trizen repository from the AUR
	git clone https://aur.archlinux.org/trizen.git
	# Navigate into the trizen directory
	cd trizen || exit
	# Build and install trizen
	makepkg -si
}

# ----------------- #
# Install Ulauncher #
# ----------------- #
git clone https://aur.archlinux.org/ulauncher.git
cd ulauncher && makepkg -is

# -------------------- #
# Install Apps & Tools #
# -------------------- #
i_xdman() { # xdman(Download Manager)
	sudo pacman -S --noconfirm jdk-openjdk yt-dlp
	yay -S --noconfirm youtube-dl xdman --noconfirm
}
i_FDM() {
	yay -S freedownloadmanager
}
i_motrix() { # motrix(Download Manager)
	yay -S --noconfirm motrix
}

# Install Browsers
i_chrome() { # Install Google Chrome
	yay -S --noconfirm google-chrome
}
i_msedge() { # Install Microsoft Edge
	yay -S --noconfirm microsoft-edge-stable-bin
}

# Install and Configure Terminals
i_zsh() { # Install ZSH & oh-my-zsh
	sudo pacman -S --noconfirm zsh fzf
	# Install Plugins
	cd ~/.oh-my-zsh/custom/plugins/ || exit
	# Install zsh-autocomplete
	git clone https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autocomplete
	# Install zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
	# Install zsh-history-substring-search
	git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-history-substring-search
	# Install zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
	# Set ZSH as default
	chsh -s /bin/zsh
	# Update ZSH
	exec zsh || exec bash
	# Reload the configuration file (optional)
	source ~/.zshrc
}

# -----------------------------------------------------
# Install GStreamer Plugins
# This should provide support for most media formats
# -----------------------------------------------------
i_GStreamer() {
	sudo pacman -S gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gstreamer gst-libav
}

# Install Editors
i_vsCode() { # Install Microsoft Visual Studio Code
	yay -S visual-studio-code-bin
}
# To install Zed on most Linux distributions, run this shell script:
# https://zed.dev/blog/zed-on-linux
curl -f https://zed.dev/install.sh | sh
echo "export PATH=$HOME/.local/bin:$PATH" >>~/.zshrc
source ~/.zshrc

# =============================================================
# Install Programming Languages & Famous Development Tools
# and Frameworks, Tools that related to Web Development Stack.
# =============================================================
# NodeJS
i_nodeJS() { # NodeJS
	# installs nvm (Node Version Manager)
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
	# download and install Node.js (you may need to restart the terminal)
	nvm install 22
	# verifies the right Node.js version is in the environment
	node -v # should print `v22.7.0`
	# verifies the right npm version is in the environment
	npm -v # should print `10.8.2`

	# Set NPM Configurations
	npm config set registry https://registry.npmjs.org/
	npm config set prefer-offline true
	npm config set maxsockets 50
	npm config set fetch-retries 100
	npm config set fetch-retry-mintimeout 999999
	npm config set fetch-retry-maxtimeout 999999

	# Install yarn
	sudo pacman -S --noconfirm yarn
	yarn config set registry https://registry.yarnpkg.com/

	# Install pnpm
	sudo pacman -S --noconfirm pnpm
}
# Rust
# Dart
# Ruby
# GO
# C++
# C#
# python

# ---------------------
# Overclocking tools
# ---------------------
sudo pacman -S vulkan-tools qt5-wayland xf86-video-amdgpu
yay -S corectrl

# ------------------------------------------- #
# Install Flatpak Applications and Extensions #
# ------------------------------------------- #
i_flatpak() {
	sudo pacman -S flatpak --noconfirm
	# Add the Flathub remote
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# Reboot your system (optional) Rebooting ensures that everything is properly set up, but its not strictly necessary.
	# sudo reboot
	# Increase the timeout settings for Flatpak
	FLATPAK_CONF="/etc/flatpak/flatpak.conf"
	echo "[Network]" | sudo tee -a $FLATPAK_CONF >/dev/null
	echo "RequestTimeout=1000" | sudo tee -a $FLATPAK_CONF >/dev/null
	echo "Timeout settings updated in $FLATPAK_CONF"
	# List of Flatpak applications to install
	Applications=(
		# ------------------------------------------- // Audio/Video
		"com.github.rafostar.Clapper"      # Clapper
		"com.github.unrud.VideoDownloader" # Video Downloader
		"com.obsproject.Studio"            # OBS Studio
		"net.base_art.Glide"               # Glide
		"org.audacityteam.Audacity"        # Audacity
		"org.kde.kdenlive"                 # Kdenlive
		"org.gnome.eog"                    # Image Viewer

		# ------------------------------------------- // System
		"com.github.tchx84.Flatseal"       # Flatseal
		"com.mattjakeman.ExtensionManager" # Extension Manager
		"io.github.flattool.Warehouse"     # Warehouse
		"io.gitlab.adhami3310.Impression"  # Impression
		"io.missioncenter.MissionCenter"   # Mission Center
		"net.nokyan.Resources"             # Resources
		"org.filezillaproject.Filezilla"   # Filezilla
		"org.gnome.Boxes"                  # Boxes
		"org.gnome.Calculator"             # Calculator
		"org.gnome.Connections"            # Connections
		"org.gnome.Loupe"                  # Loupe
		"org.gnome.Photos"                 # Photos
		"fr.romainvigier.MetadataCleaner"  # Metadata Cleaner

		# ------------------------------------------- // Browser
		"com.google.Chrome"   # Google Chrome
		"com.microsoft.Edge"  # Microsoft Edge
		"org.mozilla.firefox" # Firefox

		# ------------------------------------------- // Social
		"com.discordapp.Discord" # Discord
		"org.telegram.desktop"   # Telegram

		# ------------------------------------------- // Productivity
		"com.jgraph.drawio.desktop"   # draw.io
		"md.obsidian.Obsidian"        # Obsidian
		"org.libreoffice.LibreOffice" # LibreOffice
		"org.mozilla.Thunderbird"     # Thunderbird

		# ------------------------------------------- // Image/Graphics
		"com.icons8.Lunacy"                  # Lunacy
		"io.gitlab.theevilskeleton.Upscaler" # Image Upscaler
		"org.blender.Blender"                # Blender
		"org.gimp.GIMP"                      # GIMP
		"org.inkscape.Inkscape"              # Inkscape
		"org.kde.krita"                      # Krita
		"org.freecadweb.FreeCAD"             # FreeCAD

		# ------------------------------------------- // Photography
		# (You can add more photography-related apps here as needed)

		# ------------------------------------------- // Gaming
		"org.gnome.Chess" # Chess

		# ------------------------------------------- // Development
		"com.getpostman.Postman"      # Postman
		"com.slack.Slack"             # Slack
		"com.visualstudio.code"       # Visual Studio Code
		"io.beekeeperstudio.Studio"   # Beekeeper Studio
		"io.dbeaver.DBeaverCommunity" # DBeaver Community
		"rest.insomnia.Insomnia"      # Insomnia
		"com.github.zadam.trilium"    # Trilium
		"org.qbittorrent.qBittorrent" # qBittorrent
	)
	# Function to install Flatpak applications
	installFlatpakApps() {
		for app in "${Applications[@]}"; do
			echo "Installing $app..."
			flatpak install flathub "$app" -y
			echo "---------------------------------------------"
		done
	}
	# Main execution
	installFlatpakApps
	echo "All Flatpak applications installed successfully."
}

# To set microsoft edge as default Browser
xdg-settings set default-web-browser com.microsoft.Edge.desktop
# to get whats you default browser?
xdg-settings get default-web-browser
# List all installed browsers #
# ls /usr/share/applications | grep edge
# ls /var/lib/flatpak/exports/share/applications | grep edge
# ls /var/lib/snapd/desktop/applications | grep edge
# To open a link in default browser #
xdg-open https://www.google.com
# To open a link in specific browser
google-chrome https://www.google.com
# Update MIME Types (Optional)
# * To ensure that all relevant MIME types are associated with Microsoft Edge, you can use the xdg-mime command:
xdg-mime default com.microsoft.Edge.desktop x-scheme-handler/http
xdg-mime default com.microsoft.Edge.desktop x-scheme-handler/https
xdg-mime default com.microsoft.Edge.desktop text/html
xdg-mime default com.microsoft.Edge.desktop application/xhtml+xml
xdg-mime default com.microsoft.Edge.desktop application/xml
xdg-mime default com.microsoft.Edge.desktop application/x-extension-htm
xdg-mime default com.microsoft.Edge.desktop application/x-extension-html
xdg-mime default com.microsoft.Edge.desktop application/x-extension-shtml
xdg-mime default com.microsoft.Edge.desktop application/x-extension-xht
xdg-mime default com.microsoft.Edge.desktop application/x-extension-xhtml

# ------------------------------- #
# Switch to a gdm Display Manager #
# ------------------------------- #
sudo pacman -S gdm
sudo systemctl disable sddm.service
sudo systemctl enable gdm.service
sudo systemctl start gdm.service

# -------------------------- #
# Increase the Size of tmpfs #
# -------------------------- #
#* This will allow you to have a larger temporary directory, which can be useful for tools that use temporary files.
#* This will fix ERROR: Failed to write file “/run/user/1000/.flatpak/....”: write() failed: No space left on device

mount | grep /run/user/1000 # Check if it's a tmpfs.
sudo chown 1000:1000 /run/user/1000
sudo chmod 700 /run/user/1000
echo 'tmpfs /run/user/1000 tmpfs size=4G,mode=700,uid=1000,gid=1000 0 0' | sudo tee -a /etc/fstab
d /run/user/1000 0700 softeng softeng 4G
sudo systemd-tmpfiles --create
mkdir -p /run/user/"$(id -u)"
export XDG_RUNTIME_DIR
XDG_RUNTIME_DIR=/run/user/"$(id -u)"

# check if it's a tmpfs
df -h /run/user/1000 /run/user/1000

# ------------------------- #
# update the packages again #
# ------------------------- #
update_packages

# --------------------- #
# Clear Temporary Files #
# --------------------- #
sudo rm -rf /tmp/*

echo 'Scrip	Completed!'
echo 'Done!'
