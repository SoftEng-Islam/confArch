#!/bin/bash
pacman -S --needed --noconfirm base-devel git
sudo pacman -S --noconfirm gedit vlc ffmpeg gstreamer gst-plugins-good gst-plugins-ugly libdvdcss gnome gnome-shell-extensions wayland xorg-server xf86-input-libinput mesa xf86-video-amdgpu linux-headers mesa lib32-mesa
yay -S gtk-engine-murrine

# Update system and install packages using pacman
sudo pacman -Syu --needed \
    ttf-liberation \
    vlc \
    gnome-tweaks \
    git \
    ffmpegthumbs \
    boost \
    gstreamer \
    gstreamer0.10 \
    gstreamer0.10-bad \
    gstreamer0.10-bad-plugins \
    gstreamer0.10-base \
    gstreamer0.10-base-plugins \
    gstreamer0.10-good \
    gstreamer0.10-good-plugins \
    gstreamer0.10-ugly \
    gstreamer0.10-ugly-plugins \
    gstreamer0.10-openh264 \
    gstreamer0.10-libav \
    gstreamer \
    gstreamer1-plugins-base \
    gstreamer1-plugins-good \
    gstreamer1-plugin-openh264 \
    gstreamer1-libav \
    gnome-tweaks \
    gnome-extensions-app \
    grub-customizer \
    networkmanager-tui \
    aircrack-ng \
    clang \
    dbus \
    gperf \
    gtk3 \
    libnotify \
    gnome-keyring \
    libcap \
    cups \
    libxtst \
    alsa-lib \
    libxrandr \
    nss \
    python-dbusmock \
    libpcap \
    gcc \
    hcxtools \
    libxss \
    rustup \
    corectrl \
    execstack \
    devscripts \
    ncurses \
    ncurses5-compat-libs \
    pnpm \
    yarn \
    bun \
    libsoup \
    javascriptcoregtk \
    webkit2gtk \
    grpc \
    firewalld \


# Install packages from AUR using yay
yay -S --needed \
    gstreamer1-plugins-bad \
    gstreamer1-plugins-good \
    gstreamer1-plugins-base \
    gstreamer1-plugin-openh264 \
    gstreamer1-libav \
    gstreamer1-plugins-bad-free-devel \
    networkmanager-tui \
    gnome-tweaks \
    gnome-extensions-app \
    execstack-0.5.0-27.fc40.x86_64 \
    devscripts \
    ncurses \
    ncurses-compat-libs \
    pnpm \
    yarn \
    bun \
    libsoup \
    javascriptcoregtk \
    webkit2gtk \
    grpc \
    firewalld \
    nwg-shell \
    lxappearance \
