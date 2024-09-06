#!/bin/bash
# shellcheck disable=SC2034
# -----------------------------------------------
# variable to hold user preferances
# 1= true or Enable or Install or add
# 0= false or Disable or don't install
# -----------------------------------------------

# System
gnome=1      # Install Or Improve Gnome
hyprland=1   # Install Or Improve Hyprland
gtk_themes=1 # Install GTK Themes
dotFiles=1   # Install Dotfiles and configs for Hyprland
icons=1      # Install Icons
bibata=1     # Cursor Icons
plymouth=1   # Install plymouth-themes
fonts=1      # Install Fonts
ZSH=1        # Install ZSH & OH-MY-ZSH
wineHQ=1     # Install WineHQ
Pomodoro=1   # Install Pomodoro
drivers=0    # Install Drivers
networks=1   # Install Network Tools and inhancements

# Apps
LibreOffice=1      # Install LibreOffice
Brave=0            # Install Brave Browser
Slack=1            # Install Slack
Discord=1          # Install Discord
Spotify=0          # Install Spotify
VisualStudioCode=1 # Install Visual Studio Code (vscode)
SublimeText=0      # Install Sublime Text
Atom=0             # Install Atom
Emacs=0            # Install Emacs
Vim=0              # Install Vim
Zed=1              # Install Zed Editor

# ------------------------------------------------
# Install Programming Languages for Developers
# ------------------------------------------------
c=1
cpp=1
csharp=1
rust=1
python=1
go=1
ruby=1
java=1
php=1
nodejs=1
dart=1
flutter=1
