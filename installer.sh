#!/bin/sh


directory=$(pwd)
echo "Enter the name of the disk"
read disk
if   $(fdisk -l |  grep  $disk); 
then 
	echo "The disk couldn't be found"
	exit 1;
fi	

gdisk $disk
wait
cryptsetup luksFormat --type luks1 ${disk}3
wait
cryptsetup open ${disk}3 cryptlvm
wait
pvcreate /dev/mapper/cryptlvm
vgcreate VolumeGroup /dev/mapper/cryptlvm
echo "Enter root partition size in Gigabytes"
read root_size
wait
lvcreate -L ${root_size}G VolumeGroup -n root
lvcreate -l 100%FREE VolumeGroup -n home
lvreduce -L -256M VolumeGroup/home
mkfs.ext4 /dev/VolumeGroup/root
mkfs.ext4 /dev/VolumeGroup/home
mkfs.fat -F 32 "${disk}2"
wait

mount  /dev/VolumeGroup/root /mnt
mount --mkdir /dev/VolumeGroup/home /mnt/home
mount --mkdir "${disk}2" /mnt/efi




wait
pacstrap -K /mnt base base-devel linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab
cp "${directory}/chroot.sh" /mnt/chroot.sh
arch-chroot /mnt /bin/bash /chroot.sh
wait 
rm /mnt/chroot.sh
echo "Done" 
