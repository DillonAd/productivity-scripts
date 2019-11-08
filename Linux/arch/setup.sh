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
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

# Encrypted Swap
echo 'swap LABEL=cryptswap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=512' >> /etc/crypttab
echo '/dev/mapper/swap none swap defaults 0 0' >> /etc/fdisk

# Install GRUB bootloader
pacman -S --noconfirm grub-bios

# GRUB ecrypted drive
sed -i 's#^\(GRUB_CMDLINE_LINUX="\)#cryptdevice=/dev/sda2:cryptroot#' /etc/default/grub

# Configure GRUB bootloader
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# mkinitcpio config
sed -i 's/^\(HOOKS=".*\)\(filesystems.*\)/ encrypt /' /etc/mkinitcpio.conf

# Initramfs configuration
mkinitcpio -p linux

# Set root password
echo Enter new root password
read NEW_PASS
echo 'root:$NEW_PASS' | chpasswd

# Intel microcode
#pacman -Sy --noconfirm intel-ucode

# Setup systemd
# bootctl install

# SDA2_UUID=$(blkid -s UUID -o value /dev/sda2)

# echo "title Arch Linux
# linux /vmlinuz-linux
# initrd /intel-ucode.img
# initrd /initramfs-linux.img
# options rd.luks.name=${SDA2_UUID}=cryptroot root=/dev/mapper/cryptroot rw" > /boot/loader/entries/arch.conf
