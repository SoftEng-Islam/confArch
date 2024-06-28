# The Welcome Section
echo -e "$(cat <<EOF

Welcome \e[1;32m$(whoami)\e[0m
Today's date is: \e[93m$(date)\e[0m \n
feel free to message me on Twitter: https://x.com/SoftEng_Islam


EOF
)"



#########################
# Update the Packages
#########################
echo 'update the packages'
sudo -i
pacman -Syu --noconfirm && pacman -Sc --noconfirm

###############################
# Install Packages with pacman
###############################
echo 'Install Needed Packages'
pacman -S --needed --noconfirm base-devel git
sudo pacman -S --noconfirm gedit vlc ffmpeg gstreamer gst-plugins-good gst-plugins-ugly libdvdcss gnome gnome-shell-extensions wayland xorg-server xf86-input-libinput mesa xf86-video-amdgpu linux-headers mesa lib32-mesa

# Microsoft Partition FileSystem Format 'NTFS'
echo 'Install ntfs-3g to Support MS partition file system'
pacman -Sy ntfs-3g
modprobe fuse

# Install ZSH & oh-my-zsh
sudo pacman -S zsh
chsh -s /bin/zsh


# Kitty terminal emulator
echo 'Install Kitty terminal emulator'
sudo pacman -S kitty
echo 'Set Kitty as the Default Terminal:'
export TERMINAL=kitty
# Kitty's configuration file can be found at ~/.config/kitty/kitty.conf.
# You can customize Kitty's appearance and behavior by editing this file.



#############################
# Install firewalld
#############################
sudo pacman -S firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo tee /etc/NetworkManager/conf.d/00-local.conf << EOF > /dev/null
[main]
firewall-backend=none
EOF
sudo systemctl restart NetworkManager.service
sudo firewall-cmd --permanent --new-policy=egress-shared
sudo firewall-cmd --permanent --policy=egress-shared --set-target=ACCEPT
sudo firewall-cmd --permanent --policy=egress-shared --add-ingress-zone=nm-shared
sudo firewall-cmd --permanent --policy=egress-shared --add-egress-zone=trusted
sudo firewall-cmd --permanent --policy=egress-shared --add-masquerade

sudo firewall-cmd --permanent --new-policy=ingress-shared
sudo firewall-cmd --permanent --policy=ingress-shared --set-target=ACCEPT
sudo firewall-cmd --permanent --policy=ingress-shared --add-ingress-zone=trusted
sudo firewall-cmd --permanent --policy=ingress-shared --add-egress-zone=nm-shared
sudo firewall-cmd --reload


# ######################
# install-OneUI
########################

#####################
# install-bibata
#####################



#####################################
# Install Fonts
#####################################
echo 'Use yay to install JetBrains Mono:'
# To Verify the installation:
# ls /usr/share/fonts/TTF | grep JetBrains
yay -S ttf-jetbrains-mono
# Update the font cache:
echo 'Update the font Cache'
sudo fc-cache -fv





echo 'Disable Gnome Check-alive'
gsettings set org.gnome.mutter check-alive-timeout 0




pacman -S flatpak --noconfirm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# increase the timeout settings for Flatpak
FLATPAK_CONF="/etc/flatpak/flatpak.conf"
echo "[Network]" >> $FLATPAK_CONF
# Increase timeout settings (adjust as needed)
echo "RequestTimeout=800" >> $FLATPAK_CONF
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









echo 'Install yay'
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo 'Install debtap by yay'
yay -S debtap

echo 'Initialize `debtap` (only needed the first time)'
debtap -u



##########################
# Install Apps
# `flatpak install -y flathub com.visualstudio.code org.mozilla.firefox`
##########################
echo 'Installing Resources App'
flatpak install flathub com.visualstudio.code  org.mozilla.firefox
net.nokyan.Resources com.microsoft.Edge com.google.Chrome com.mattjakeman.ExtensionManager org.qbittorrent.qBittorrent com.protonvpn.www com.github.zadam.trilium



# List of Flatpak applications to install (replace with your desired apps)
APPS=(
	"com.visualstudio.code"
	"org.mozilla.firefox"
	"net.nokyan.Resources"
	"com.microsoft.Edge"
	"com.google.Chrome"
	"com.mattjakeman.ExtensionManager"
	"org.qbittorrent.qBittorrent"
	"com.protonvpn.www"
	"com.github.zadam.trilium"
	org.gnome.Boxes
	com.getpostman.Postman
	io.dbeaver.DBeaverCommunity
	rest.insomnia.Insomnia
	com.discordapp.Discord
	org.telegram.desktop
	org.libreoffice.LibreOffice
	org.mozilla.Thunderbird

	# Add more applications as needed
)
# Function to install Flatpak applications
install_flatpak_apps() {
	for app in "${APPS[@]}"; do
		echo "Installing $app..."
		flatpak install flathub $app -y
		echo "---------------------------------------------"
	done
	}
# Main execution
install_flatpak_apps
echo "All Flatpak applications installed successfully."
