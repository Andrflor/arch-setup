#!/bin/bash

echo "Post-Installation"

# Create user and set password
read -p "Set user name: " userName
useradd -m -G wheel,storage,audio,video -s /bin/bash $userName
echo "Set user password:"
passwd $userName

# Install LTS kernel
pacman -S --noconfirm linux-lts

# Install header files and scripts for building modules for Linux kernel
pacman -S --noconfirm linux-headers linux-lts-headers

# Install important services
pacman -S --noconfirm acpid ntp cronie avahi nss-mdns dbus cups ufw tlp

# Configure the network
pacman -S --noconfirm dialog dhclient 
pacman -S --noconfirm networkmanager network-manager-applet

# Install command line and ncurses programs
pacman -S --noconfirm sudo
pacman -S --noconfirm bash-completion
pacman -S --noconfirm smbclient
pacman -S --noconfirm tree
pacman -S --noconfirm atool
pacman -S --noconfirm ranger w3m mpv
pacman -S --noconfirm pulseaudio pulseaudio-alsa
pacman -S --noconfirm htop
pacman -S --noconfirm tmux
pacman -S --noconfirm youtube-dl
pacman -S --noconfirm wget curl axel
pacman -S --noconfirm rsync
pacman -S --noconfirm scrot
pacman -S --noconfirm xdotool
pacman -S --noconfirm xclip xsel
pacman -S --noconfirm lshw
pacman -S --noconfirm acpi
pacman -S --noconfirm nmap
pacman -S --noconfirm vim
pacman -S --noconfirm ffmpeg
pacman -S --noconfirm git
pacman -S --noconfirm go go-tools
pacman -S --noconfirm feh
pacman -S --noconfirm openssh
pacman -S --noconfirm openvpn easy-rsa
pacman -S --noconfirm rtorrent

# Install xorg and graphics
pacman -S --noconfirm xorg xorg-xinit libva-intel-driver mesa
pacman -S --noconfirm xf86-video-intel xf86-input-synaptics

# Install fonts
pacman -S --noconfirm ttf-droid ttf-ionicons ttf-dejavu

# Install window manager
pacman -S --noconfirm bspwm dmenu compton

# Install GTK-Theme and Icons
pacman -S --noconfirm arc-gtk-theme hicolor-icon-theme papirus-icon-theme

# Install graphical programs
pacman -S --noconfirm rxvt-unicode
pacman -S --noconfirm dunst
pacman -S --noconfirm pavucontrol
pacman -S --noconfirm qemu
pacman -S --noconfirm docker docker-compose

# Add user to docker group
gpasswd -a $userName docker

# Add user to VirtualBox group
gpasswd -a $userName vboxusers

# Samba config
mkdir /etc/samba
touch /etc/samba/smb.conf

# Avahi provides local hostname resolution using a "hostname.local" naming scheme
sed -i '/hosts:/s/mymachines/mymachines mdns_minimal [NOTFOUND=return]/' /etc/nsswitch.conf

# Configure sudo
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Allow to execute shutdown without password
echo "$userName ALL = NOPASSWD: /usr/bin/shutdown" >> /etc/sudoers

# Add Cron job for monitoring battery
{ crontab -l -u $userName; echo "*/5 * * * * env DISPLAY=:0  /home/$userName/.bin/BatteryWarning.sh"; } | crontab -u $userName -

# Disable powersave, prevent the WiFi card from automatically sleeping and halting connection
echo "options rtl8723be fwlps=0" > /etc/modprobe.d/rtl8723be.conf

# Configure synaptics and intel drivers
cp -R /arch-setup/config/xorg/. /etc/X11/xorg.conf.d/

# Copy all home folder files
cp -R /arch-setup/config/home/. /home/$userName/
cp -R /arch-setup/config/home/. /root/

# Compile the rsync extension
g++ /home/$userName/.bin/Rsync.cpp -o /home/$userName/.bin/Rsync
rm /home/$userName/.bin/Rsync.cpp

# Change premissions
chown -R $userName:$userName /home/$userName/
chmod -R 700 /home/$userName/.bin/

# Install Yay
wget "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" -O - | tar xz -C /tmp
chown -R $userName:$userName /tmp/yay/
sudo -u $userName bash -c 'cd /tmp/yay && makepkg -s'
pacman -U --noconfirm /tmp/yay/yay*.pkg.tar.xz

# Install Polybar
pacman -S --noconfirm jsoncpp libuv rhash cmake
wget "https://aur.archlinux.org/cgit/aur.git/snapshot/polybar.tar.gz" -O - | tar xz -C /tmp
chown -R $userName:$userName /tmp/polybar/
sudo -u $userName bash -c 'cd /tmp/polybar && makepkg -s'
pacman -U --noconfirm /tmp/polybar/polybar*.pkg.tar.xz

# Add blackarch to the PPA
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
./strap.sh

# Clean up and optimize pacman
pacman -Sc --noconfirm && pacman-optimize
