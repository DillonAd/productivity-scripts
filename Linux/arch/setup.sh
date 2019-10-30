#!/bin/bash

# Set Timezone
ln -sf /usr/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc

# Localization
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Network Configuration
echo Enter hostname:
read HOSTNAME
echo $HOSTNAME > /etc/hostname

echo "
127.0.0.1	localhost
::1		    localhost
127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME"  >> /etc/hosts

# VConsole Config
echo '' > /etc/vconsole.conf

# mkinitcpio config
cat /etc/mkinitcpio.conf
read -p "press any key to continue"
sed -i s/'HOOKS=([0-9A-Za-z ].*)'/'HOOKS=(base systemd udev autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck)'/ /etc/mkinitcpio.conf

# Initramfs configuration
mkinitcpio -P

# Set root password
echo Enter new root password
read NEW_PASS
echo 'root:$NEW_PASS' | chpasswd

# Encrypted Swap
echo 'swap LABEL=cryptswap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=512' >> /etc/crypttab
echo '/dev/mapper/swap none swap defaults 0 0' >> /etc/fdisk

# Intel microcode
pacman -Sy --noconfirm intel-ucode

# Setup systemd
bootctl install

SDA2_UUID=$(blkid -s UUID -o value /dev/sda2)

echo "title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options rd.luks.name=${SDA2_UUID}=cryptroot root=/dev/mapper/cryptroot rw" > /boot/loader/entries/arch.conf

# Network Manager
systemctl enable NetworkManager
systemctl start NetworkManager