#!/bin/bash

# https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  3 # partition number 3
    # default - start at beginning of disk 
  +3072M  # 3072 MB swap partition
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M  # 512 MB boot partition
  n # new partition
  p # primary partition
  2 # partition number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Encrypt main partition
cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 /dev/sda2
cryptsetup open /dev/sda2 cryptroot
mkfs.ext4 /dev/mapper/cryptroot

# Mount the main partition
mount /dev/mapper/cryptroot /mnt

# Format and enable swap partition
mkswap /dev/sda3
swapon /dev/sda3

# Format and enable boot partiton
mkfs.fat -F32 /dev/sda1
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Bootstrap necessary packages
pacstrap /mnt base linux linux-firmware iproute2 gnome budgie-desktop vim

# Propagate partition config to disk
genfstab -U /mnt >> /mnt/etc/fstab

# CHROOT into the new installation
arch-chroot /mnt

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