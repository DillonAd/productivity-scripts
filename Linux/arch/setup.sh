#!/bin/bash

# Set Timezone
ln -sf /usr/share/zoneinfo/US/Central /etc/local
ln -sf /usr/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc

# Localization
sed -i s/'#en_US.UTF-8 UTF-8'/'en_US.UTF-8 UTF-8'/ /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# VConsole Config
echo '' > /etc/vconsole.conf

# Network Configuration
echo Enter hostname:
read HOSTNAME
echo $HOSTNAME > /etc/hostname

echo "
127.0.0.1	 localhost
::1		     localhost
127.0.0.1    $HOSTNAME.localdomain    $HOSTNAME"  >> /etc/hosts

# Network Manager
pacman -Sy --noconfirm networkmanager
systemctl enable NetworkManager

# Encrypted Swap
echo 'swap LABEL=cryptswap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=512' >> /etc/crypttab
echo '/dev/mapper/swap none swap defaults 0 0' >> /etc/fdisk

# Install GRUB bootloader
pacman -Sy --noconfirm grub grub-bios

# GRUB ecrypted drive
sed -i 's#^\(GRUB_CMDLINE_LINUX="\)#GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:cryptroot#' /etc/default/grub
sed -i 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/' /etc/default/grub

# mkinitcpio config
sed -i '/^HOOK/s/filesystems/encrypt filesystems/' /etc/mkinitcpio.conf

# Initramfs configuration
mkinitcpio -p linux

# Intel microcode
pacman -Sy --noconfirm intel-ucode

# Configure GRUB bootloader
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Set root password
echo Enter new root password
read NEW_PASS
echo 'root:$NEW_PASS' | chpasswd
clear