#!/bin/sh



echo "Enter the name of the disk"
read disk
if  [[  $(fdisk -l |  grep  $disk) ]]; 
then 
	echo "The disk couldn't be found"
	exit 1;
fi	

fdisk $disk
wait
mkfs.ext4 /dev/root
mkfs.fat -F 32 /dev/efi
wait
mount /dev/root /mnt
mount --mkdir /dev/efi /mnt/boot
wait
pacstrap -K /mnt base linux linux-firmware vim grub 

gensfstab -U /mnt >> /mnt/etc/fstab
 
