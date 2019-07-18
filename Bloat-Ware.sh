#!/bin/bash

echo "Bloat-Ware"

pacman -S --noconfirm firefox
pacman -S --noconfirm gnome-calculator
pacman -S --noconfirm jdk8-openjdk gradle
pacman -S --noconfirm gimp
pacman -S --noconfirm blender
pacman -S --noconfirm inkscape
pacman -S --noconfirm gparted dosfstools ntfs-3g mtools
pacman -S --noconfirm pcmanfm-gtk3 gvfs udisks2 libmtp mtpfs gvfs-mtp
pacman -S --noconfirm file-roller unrar p7zip lrzip
pacman -S --noconfirm gutenprint ghostscript gsfonts
pacman -S --noconfirm system-config-printer gtk3-print-backends simple-scan
pacman -S --noconfirm virtualbox virtualbox-host-modules-arch virtualbox-guest-iso

yay -S --noconfirm wps-office
yay -S --noconfirm
