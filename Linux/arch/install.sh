#!/bin/bash

# Update System Clock
timedatectl set-ntp true

# https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  g # clear the in memory partition table and replace with a gpt table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M  # 512 MB boot partition
  t # change partition type
  1 # EFI System type
  n # new partition
  3 # partition number 3
    # default - start at beginning of disk 
  +4096M  # 4096 MB swap partition
  t # change partition type
  3 # partition 3
  19 # Linux swap type
  n # new partition
  2 # partition number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  t # change partition type
  2 # partition 2
  20 # Linux filesystem type
  p # print the in-memory partition table
  w # write the partition table
EOF

# Encrypt main partition
cryptsetup luksFormat --type luks1 --cipher aes-xts-plain64 --key-size 512 /dev/sda2
cryptsetup open /dev/sda2 cryptroot
mkfs.ext4 /dev/mapper/cryptroot

# Format and enable boot partiton
mkfs.fat -F32 -n BOOT /dev/sda1
mkdir /mnt/boot/EFI

# Format and enable swap partition
#mkfs.ext4 -L cryptswap /dev/sda3
mkswap /dev/sda3
swapon /dev/sda3

# Mount the file system
mount /dev/mapper/cryptroot /mnt
mount /dev/sda1 /mnt/boot/EFI

# Bootstrap necessary packages
pacstrap /mnt base base-devel linux linux-firmware iproute2 vim wget grub efibootmgr dosfstools os-prober mtools

# Propagate partition config to disk
genfstab -U /mnt >> /mnt/etc/fstab

# CHROOT into the new installation
arch-chroot /mnt