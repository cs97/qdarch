#!/bin/bash

wifi-menu

#cfdisk /dev/$SYSDISK
cfdisk /dev/sda

modprobe dm-crypt
#cryptsetup -c aes-xts-plain -y -s 512 luksFormat /dev/$ROOT
cryptsetup -c aes-xts-plain -y -s 512 luksFormat /dev/sda2
#cryptsetup luksOpen /dev/$ROOT lvm
cryptsetup luksOpen /dev/sda2 lvm
pvcreate /dev/mapper/lvm
vgcreate vgarch /dev/mapper/lvm
lvcreate -n lvroot -L 20G vgarch
lvcreate -n lvhome -l 100%FREE vgarch

#mkfs.ext4 /dev/$BOOT
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/mapper/vgarch-lvroot
mkfs.ext4 /dev/mapper/vgarch-lvhome

mount /dev/mapper/vgarch-lvroot /mnt
mkdir /mnt/boot
#mount /dev/$BOOT /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/home
mount /dev/mapper/vgarch-lvhome /mnt/home

#nano /etc/pacman.d/mirrorlist

#pacstrap /mnt base base-devel linux linux-hardened linux-firmware nano dhcpcd syslinux
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd syslinux

genfstab -U -p /mnt > /mnt/etc/fstab
syslinux-install_update -i -a -m -c /mnt

#sed s/sysdisk/$ROOT/g syslinux.cfg > /mnt/boot/syslinux/syslinux.cfg
sed s/sysdisk/sda2/g syslinux.cfg > /mnt/boot/syslinux/syslinux.cfg

cp -r /root/qdarch /mnt/root/installer

arch-chroot /mnt /bin/bash -c '/root/installer/doinchroot.sh'

echo "################"
echo "REBOOT NOW!"
echo "################"
