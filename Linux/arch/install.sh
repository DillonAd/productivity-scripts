#!/bin/bash

pacman -Sy --noconfirm gdisk

# https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M  # 512 MB boot partition
  a # make parition 1 bootable
  t # change partition type
  b # WD95 FAT32
  n # new partition
  p # primary partition
  3 # partition number 3
    # default - start at beginning of disk 
  +3072M  # 3072 MB swap partition
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

# Format and enable boot partiton
mkfs.vfat -F32 /dev/sda1
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Format and enable swap partition
mkswap /dev/sda3
swapon /dev/sda3

# Bootstrap necessary packages
pacstrap /mnt base linux linux-firmware
# iproute2 gnome budgie-desktop vim

# Propagate partition config to disk
genfstab -U /mnt >> /mnt/etc/fstab

# CHROOT into the new installation
arch-chroot /mnt