#! /bin/bash

#username
USERNAME='you'

set_locale='0'  # 0=em_US : 1=de_DE

case $1 in
  "1")
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
    echo "de_DE ISO-8859-1" >> /etc/locale.gen
    echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen
  *)
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    echo "en_US ISO-8859-1" >> /etc/locale.gen;;
esac
locale-gen

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc --utc

echo "MODULES=()" > /etc/mkinitcpio.conf
echo "BINARIES=()" >> /etc/mkinitcpio.conf
echo "FILES=()" >> /etc/mkinitcpio.conf
echo "HOOKS=(base udev autodetect modconf block keyboard keymap encrypt lvm2 filesystems fsck)" >> /etc/mkinitcpio.conf

mkinitcpio -p linux
systemctl enable dhcpcd
clear

#passwd
passwd -l root

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

pacman -S acpid ntp dbus avahi cups cronie --noconfirm
systemctl enable cronie
systemctl enable acpid
systemctl enable ntpd
systemctl enable avahi-daemon
systemctl enable org.cups.cupsd.service
#nano /etc/ntp.conf
ntpd -gq
pacman -S xorg-server xorg-xinit xorg-apps --noconfirm

#INTEL / AMD
#pacman -S xf86-video-intel --noconfirm
pacman -S xf86-video-amdgpu --noconfirm

#keyboard.conf
#localectl set-x11-keymap us pc104
printf 'Section "InputClass"'>/etc/X11/xorg.conf.d/20-keyboard.conf
printf '\tIdentifier "keyboard"'>>/etc/X11/xorg.conf.d/20-keyboard.conf
printf '\tMatchIsKeyboard "yes"'>>/etc/X11/xorg.conf.d/20-keyboard.conf
printf '\tOption "XkbLayout" "de"'>>/etc/X11/xorg.conf.d/20-keyboard.conf
printf '\tOption "XkbModel" "pc105"'>>/etc/X11/xorg.conf.d/20-keyboard.conf
printf '\tOption "XkbVariant" "de_nodeadkeys"'>>/etc/X11/xorg.conf.d/20-keyboard.conf
printf 'EndSection'>>/etc/X11/xorg.conf.d/20-keyboard.conf

pacman -S xorg-twm xorg-xclock xterm --noconfirm
echo "exec i3" >> ~/.xinitrc

#Desktop packete
pacman -S i3 feh ttf-dejavu scrot thunar file-roller i3lock gvfs alsa alsa-utils pulseaudio sudo conky --noconfirm

#wifi
pacman -S wpa_supplicant netctl dialog --noconfirm

#usermake
useradd -m -g users -s /bin/bash $USERNAME
gpasswd -a $USERNAME wheel
cp ~/.xinitrc /home/$USERNAME/.xinitrc
mkdir /home/$USERNAME/.config
mkdir /home/$USERNAME/.config/i3
cp /root/installer/i3 /home/$USERNAME/.config/i3/config
cp /root/installer/conky.conf /home/$USERNAME/conky.conf
chown $USERNAME:users .config
chmod 770 .config
echo "$USERNAME passwort:"
passwd $USERNAME
#echo "setxkbmap de" >> /home/$USERNAME/.bashrc

#wallpaper
#cp /root/installer/tpbh.png /home/$USERNAME/tpbh.png

#other stuff
pacman -S cdrtools gedit screenfetch firefox openssh transmission-gtk htop cpupower--noconfirm

#Virtualbox
pacman -S virtualbox virtualbox-host-modules-arch --noconfirm
gpasswd -a $USERNAME vboxusers

#fastboot android
#pacman -S fastboot --noconfirm
