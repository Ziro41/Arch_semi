ln -sf /usr/share/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc
vim /etc/locale.gen
wait
locale-gen
pacman -Syu
pacman -S linux-headers pipewire mesa grub mtools sudo openssh networkmanager efibootmgr bluez bluez-utils xf86-video-intel xorg lightdm lightdm-gtk-greeter lvm2 
echo "LANG=es_AR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=es" >> /etc/vconsole.conf
echo "Zarch" >> /etc/hostname
echo "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\tZarch.localdomain\tZarch" >> /etc/hosts
passwd
wait
useradd -Gm  users  ziro
passwd ziro
wait
EDITOR=vim visudo
wait
vim /etc/mknitcpio.conf
vim /etc/default/grub
wait
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable bluetooth
