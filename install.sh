#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Install Nala
apt install nala -y

# Update packages list and update system
echo "Updating system..."
nala update
nala upgrade -y

echo "Installing dependencies..."

# Install basic dependencies
nala install wget pulseaudio git curl htop neofetch -y

# Install desktop dependencies
nala install feh bspwm sxhkd lightdm kitty rofi polybar picom nemo lxpolkit mpv x11-xserver-utils unzip yad pavucontrol flameshot lxappearance papirus-icon-theme -y

# Create basic folders
echo "Creating basic folders..."
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/.themes/Nordic
mkdir -p /home/$username/.icons
mkdir -p /home/$username/Pictures/Wallpapers
mkdir -p /home/$username/Downloads
mkdir -p /home/$username/.scripts

echo "Setting configuration files..."

# Copy files around
cp resources/wallpaper.jpg /home/$username/Pictures/Wallpapers/.
cp -r dotfiles/* /home/$username/.config/.
cp scripts/* /home/$username/.scripts/.

# Font Work
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
wget https://use.fontawesome.com/releases/v6.4.2/fontawesome-free-6.4.2-desktop.zip

unzip fontawesome-free-6.4.2-desktop.zip
cp fontawesome-free-6.4.2-desktop/otfs/*.otf /home/$username/.fonts/.
rm -rf fontawesome-free-6.4.2-desktop*

unzip FiraCode.zip -d /home/$username/.fonts/.
rm FiraCode.zip

fc-cache -vf

# Theming dependencies
git clone https://github.com/EliverLara/Nordic.git /home/$username/.themes/Nordic/.
tar xvf resources/165371-Breeze.tar -C /home/$username/.icons/.

# Fix ownership
chown -R $username:$username /home/$username

# Install Brave
echo "Installing Brave..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
nala update
nala install brave-browser -y

# Define Theming
touch ~/.gtkrc-2.0
echo 'gtk-theme-name="Nordic"' >> .gtkrc-2.0
echo 'gtk-icon-theme-name="Papirus"' >> .gtkrc-2.0
echo 'gtk-cursor-theme-name="Breeze"' >> .gtkrc-2.0

mkdir -p ~/.config/gtk-3.0
touch ~/.config/gtk-3.0/settings.ini

echo "[Settings]" >> ~/.config/gtk-3.0/settings.ini
echo "gtk-theme-name=Nordic" >> ~/.config/gtk-3.0/settings.ini
echo "gtk-icon-theme-name=Papirus" >> ~/.config/gtk-3.0/settings.ini
echo "gtk-cursor-theme-name=Breeze" >> ~/.config/gtk-3.0/settings.ini

echo "Configuration completed."
