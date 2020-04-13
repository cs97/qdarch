#! /bin/bash

#username
#USERNAME='you'
#locale
#set_locale='0'       # 0=em_US ; 1=de_DE
#wm
#set_wm='0'          # 0=nope ; 1=i3-wm ; 2=plasma
#gpu
#set_xf86_video='0'  # 0=intel ; 1=amd



case $lang in
  "1")
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
    echo "de_DE ISO-8859-1" >> /etc/locale.gen
    echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen;;
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

case $video in
  "0") pacman -S xf86-video-intel --noconfirm;;
  "1") pacman -S xf86-video-amdgpu --noconfirm;;
esac

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


#Desktop packete
pacman -S alsa alsa-utils pulseaudio sudo --noconfirm

#um mkv videos abzuspielen
pacman -S gst-libav


#wifi
pacman -S wpa_supplicant netctl dialog --noconfirm

#usermake
useradd -m -g users -s /bin/bash $username
gpasswd -a $username wheel
echo "$username passwort:"
passwd $username
#echo "setxkbmap de" >> /home/$USERNAME/.bashrc

#other stuff
pacman -S cdrtools gedit screenfetch firefox openssh transmission-gtk htop cpupower --noconfirm

#Virtualbox
pacman -S virtualbox virtualbox-host-modules-arch --noconfirm
gpasswd -a $username vboxusers

#fastboot android
#pacman -S fastboot --noconfirm


case $desktop in
  *) echo 'nope';;
  
  "1") #i3-wm
    pacman -S i3 feh ttf-dejavu scrot thunar file-roller i3lock gvfs conky --noconfirm
    echo "exec i3" >> ~/.xinitrc
    cp ~/.xinitrc /home/$username/.xinitrc
    mkdir /home/$username/.config
    mkdir /home/$username/.config/i3
    cp /root/installer/i3 /home/$username/.config/i3/config
    cp /root/installer/conky.conf /home/$usernameE/conky.conf
    chown $username:users /home/$username/.config
    chmod 770 /home/$username/.config;;
    
  "2") #plasma
    pacman -S xorg --noconfirm
    pacman -S plasma-meta kde-applications --noconfirm
    systemctl enable sddm
    systemctl enable NetworkManager
  ;;


esac
