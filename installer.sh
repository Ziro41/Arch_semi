#!/bin/sh



echo "Enter the name of the disk"
read disk
if   $(fdisk -l |  grep  $disk); 
then 
	echo "The disk couldn't be found"
	exit 1;
fi	

fdisk $disk
wait
mkfs.ext4 "${disk}2"
mkfs.fat -F 32 "${disk}1"
wait
mount "${disk}2" /mnt
mount --mkdir "${disk}1" /mnt/boot
wait
pacstrap -K /mnt base base-devel linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab
chroot /mnt ./chroot.sh 

