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
127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME"  >> /ect/hosts

# Initramfs configuration
mkinitcpio -P

# Set root password
echo Enter new root password
read NEW_PASS
echo 'root:$NEW_PASS' | chpasswd