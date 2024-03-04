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
mkfs.ext4 "$(disk)2"
mkfs.fat -F 32 "$(disk)1"
wait
mount "$(disk)2" /mnt
mount --mkdir "$(disk)1" /mnt/boot
wait
pacstrap -K /mnt base base-devel linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab
chroot /mnt bin/bash << "EOF"
ln -sf /usr/share/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc
vim /etc/locale.gen
wait
locale-gen
pacman -Syu
pacman -S linux-headers pipewire mesa grub mtools sudo openssh networkmanager efibootmgr bluez bluez-utils xf86-video-intel xorg lightdm lightdm-gtk-greeter 
echo "LANG=es_UTF-8" >> /etc/locale.conf
echo "KEYMAP=es" >> /etc/vconsole.conf
echo "Zarch" >> /etc/hostname
echo "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\tZarch.localdomain\tZarch" >> /etc/hosts
passwd
wait
useradd -m -f users -G ziro
passwd ziro
wait
EDITOR=vim visudo
wait
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable bluetooth
EOF 
