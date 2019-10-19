#!/bin/bash

# https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +100M # 100 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +3072M  # 3072 MB swap partition
  3 # partition number 3
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# # Format boot partition
# mkfs.ext4 /dev/sda1

# # Format main partition
# mkfs.ext4 /dev/sda3

# # Format and enable swap partition
# mkswap /dev/sda2
# swapon /dev/sda2

# # Mount the main partition
# mount /dev/sda1 /mnt

# # Bootstrap necessary packages
# pacstrap /mnt base linux linux-firmware vim iproute2 gnome budgie-desktop

# # Propagate partition config to disk
# genfstab -U /mnt >> /mnt/etc/fstab

# # CHROOT into the new installation
# arch-chroot /mnt
