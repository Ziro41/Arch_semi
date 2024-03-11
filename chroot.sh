ln -sf /usr/share/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc
vim /etc/locale.gen
wait
locale-gen
pacman -Syu
pacman -S linux-headers alsa pipewire mesa grub mtools sudo openssh networkmanager efibootmgr virtualbox-guest-utils git
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=en" >> /etc/vconsole.conf
echo "Zarch" >> /etc/hostname
echo "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\tZarch.localdomain\tZarch" >> /etc/hosts
echo "Enter root password"
passwd
wait
echo "Enter main user name"
read user
useradd -Gm  users $user
echo "Enter user password"
passwd $user
wait
EDITOR=vim visudo
wait
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable bluetooth
