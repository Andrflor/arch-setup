#!/bin/bash

{
echo "Pre-Installation"

# Update the system clock
timedatectl set-ntp true

# Partition the disks
parted -s /dev/sdb mklabel gpt
echo "mkpart ESP fat32 0% 200MiB
set 1 boot on
mkpart primary linux-swap 200MiB 4GiBw
mkpart primary ext4 4GiB 100%
quit
" | parted -s /dev/sdb

# Set up encryption with dm-crypt and LUKS
cryptsetup luksFormat -c aes-xts-plain64 -s 512 -h sha512 -y /dev/sdb3

# Open encrypted partitions
cryptsetup luksOpen /dev/sdb3 root

# Format the partitions
mkfs.fat -F32 /dev/sdb1
mkfs.ext4 /dev/mapper/root

# Mount the partitions
mount /dev/mapper/root /mnt
mkdir /mnt/boot && mount /dev/sdb1 /mnt/boot

# Select the mirrors
pacman -Sy pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
wget -O - "https://www.archlinux.org/mirrorlist/?country=FR&protocol=https&ip_version=4&use_mirror_status=on" | sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist.tmp
rankmirrors -n 10 /etc/pacman.d/mirrorlist.tmp > /etc/pacman.d/mirrorlist
rm /etc/pacman.d/mirrorlist.tmp

# Install the base packages
pacstrap /mnt base base-devel

# Configure crypttab
SWAP="$(find -L /dev/disk/by-partuuid -samefile /dev/sdb2 | cut -d/ -f5)"
echo "swap PARTUUID=$SWAP /dev/urandom swap,noearly,cipher=aes-xts-plain64,hash=sha512,size=512" >> /mnt/etc/crypttab

# Configure fstab
SDB1="$(lsblk -rno UUID /dev/sdb1)"
cat << EOF > /mnt/etc/fstab
# <device> <dir> <type> <options> <dump> <fsck>
UUID=${SDB1} /boot vfat defaults,noatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 2
/dev/mapper/swap none swap defaults 0 0
/dev/mapper/root / ext4 defaults,noatime,data=ordered 0 1
tmpfs /tmp tmpfs size=4G 0 0
EOF

# Copy the setup folder to the new system
DIR="$(dirname ${BASH_SOURCE[0]})"
cp -R $DIR /mnt/arch-setup

# Change root into the new system and run Installation.sh
arch-chroot /mnt /arch-setup/Installation.sh

# Pipe all output into log file
} |& tee -a /root/Arch-Installation.log
mv /root/Arch-Installation.log /mnt/home/$(ls /mnt/home/)/

# Reboot because systemctl & localectl are not available while chroot
umount -R /mnt
cryptsetup luksClose root
echo "Reboot, login as root and run: /arch-setup/Final-Installation.sh"
read -p "Press enter to reboot..."
reboot
