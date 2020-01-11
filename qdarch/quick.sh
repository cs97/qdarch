
#disk
SYSDISK='sda'
BOOT='sda1'
ROOT='sda2'


#loadkeys de
wifi-menu

cfdisk /dev/$SYSDISK

modprobe dm-crypt
cryptsetup -c aes-xts-plain -y -s 512 luksFormat /dev/$ROOT
cryptsetup luksOpen /dev/$ROOT lvm
pvcreate /dev/mapper/lvm
vgcreate vgarch /dev/mapper/lvm
lvcreate -n lvroot -L 20G vgarch
lvcreate -n lvhome -l 100%FREE vgarch

mkfs.ext4 /dev/$BOOT
mkfs.ext4 /dev/mapper/vgarch-lvroot
mkfs.ext4 /dev/mapper/vgarch-lvhome

mount /dev/mapper/vgarch-lvroot /mnt
mkdir /mnt/boot
mount /dev/$BOOT /mnt/boot
mkdir /mnt/home
mount /dev/mapper/vgarch-lvhome /mnt/home

#nano /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel linux linux-hardened linux-firmware nano dhcpcd syslinux

genfstab -U -p /mnt > /mnt/etc/fstab
syslinux-install_update -i -a -m -c /mnt

sed s/sysdisk/$ROOT/g syslinux.cfg > /mnt/boot/syslinux/syslinux.cfg

echo "MODULES=()" > /mnt/etc/mkinitcpio.conf
echo "BINARIES=()" >> /mnt/etc/mkinitcpio.conf
echo "FILES=()" >> /mnt/etc/mkinitcpio.conf
echo "HOOKS=(base udev autodetect modconf block keyboard keymap encrypt lvm2 filesystems fsck)" >> /mnt/etc/mkinitcpio.conf

cp -r /root/qdarch /mnt/root/installer

arch-chroot /mnt /bin/bash -c '/root/installer/doinchroot.sh'

clear

echo "################"
echo "REBOOT NOW!"
echo "################"





