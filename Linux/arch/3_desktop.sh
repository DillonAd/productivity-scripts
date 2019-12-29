#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root"
   exit 1
fi

# Install Desktop Environment
pacman -Sy --noconfirm lxdm budgie-desktop

# Install Network Manager Applet
pacman -Sy --noconfirm network-manager-applet

# Clone AUR Repositories
aur_dir=~/source/repos/aur

mkdir -p $aur_dir
cd $aur_dir

git clone https://aur.archlinux.org/brave-bin.git
git clone https://aur.archlinux.org/google-chrome.git
git clone https://aur.archlinux.org/dive.git
git clone https://aur.archlinux.org/ms-teams.git
git clone https://aur.archlinux.org/slack-desktop.git
git clone https://aur.archlinux.org/spotify.git
git clone https://aur.archlinux.org/visual-studio-code-bin.git
git clone https://aur.archlinux.org/zoom.git

for d in */ ; do
  cd $aur_dir/$d
  makepkg -is
  cd $aur_dir
done

# Install PacMan Packages
cd ~

# Sublime PGP Key
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && \
sudo pacman-key --add sublimehq-pub.gpg && \
sudo pacman-key --lsign-key 8A8F901A && \
rm sublimehq-pub.gpg

# Select Stable channel for Sublime
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | \
sudo tee -a /etc/pacman.conf

# Install Sublime
pacman -S --noconfirm sublime-text

# Install OpenSSH
pacman -S --noconfirm openssh

# Install Gnumeric
pacman -S --noconfirm gnumeric

# Install HTop
pacman -S --noconfirm htop

# Install Terminology
pacman -S --noconfirm terminology

# Install Solitaire
pacman -S --noconfirm aisleriot

# Update System
pacman -Syu --noconfirm