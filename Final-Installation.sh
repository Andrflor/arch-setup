#!/bin/bash

USR=$(ls /home/)

{
echo "Final-Installation"

# Enable important services
systemctl enable acpid
systemctl enable ntpd
systemctl enable cronie
systemctl enable avahi-daemon
systemctl enable fstrim.timer

# Enable TLP
systemctl enable tlp.service
systemctl enable tlp-sleep.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket

# Enable UFW
systemctl enable ufw
ufw default deny
ufw enable

# Configure Keyboardlayout
localectl set-x11-keymap fr

# Enable auto login on tty1
mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo "[Service]" > /etc/systemd/system/getty@tty1.service.d/override.conf
echo "ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo "ExecStart=-/usr/bin/agetty --autologin $USR --noclear %I \$TERM" >> /etc/systemd/system/getty@tty1.service.d/override.conf

# Lock root user
passwd -l root

# Finish Installation
echo "Finish!! You can remove /arch-setup/ to cleanup"
echo "Or you can install bloatwares /arch-setup/Bloat-Ware.sh"
read -p "First reboot is needed !! Press enter to reboot..."

# Pipe all output into log file
} |& tee -a /home/$USR/Arch-Installation.log

chown $USR:$USR /home/$USR/Arch-Installation.log
chmod 600 /home/$USR/Arch-Installation.log

reboot
