#!/bin/bash

pacman -Sy

x=0
while [ $x -eq 0 ] 
do 
	clear
	echo " 1) [ ] Make Keymap Fr"
	echo " 2) [ ] Refrech Arch Repos"
	echo " 3) [ ] Configure Mirrorlist"
	echo " 4) [ ] Partition Scheme"
	echo " 5) [ ] Format & mount partitions"
	echo " 6) [ ] Install Base System"
	echo " 7) [ ] Configure Fstab"
	echo " 8) [ ] Configure Hostname"
	echo " 9) [ ] Configure TimeZone"
	echo "10) [ ] Configure Hardware Clock"
	echo "11) [ ] Configure Mkinicpio"
	echo "12) [ ] Install Bootloader"
	echo "13) [ ] Root Password"
	echo 
	echo  " d) Done"
	echo  " e) Exit"
	echo 
	echo "Enter n° of options (ex: 1 2 3): " 

	read opt

case "$opt" in 
		1)
		echo "loading keymap for fr keyboard"
		loadkeys us
		sleep 0.5
		;;
		2)
		echo "refreching arch repository"
		pacman -Sy
		;;
		3)
		echo "Installing Reflector and use it"
		pacman -S --noconfirm reflector
		reflector -c "France" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
		pacman -Sy
		;;
		4)
		echo "cfdisk Disk Manager"
		cfdisk /dev/sda
		;;
		5) 
		echo " formating & mounting partitions"
		mkfs.ext4 /dev/sda1
		mount /dev/sda1 /mnt
		;;
		6)
		echo "Installing Base System"
		pacstrap /mnt base
		;;
		7)
		echo "Configure Fstab"
		genfstab -U /mnt >> /mnt/etc/fstab
		;;
		9)
		echo ""
		echo archlinux>/etc/hostname
		echo -e "\n127.0.0.1	localhost\n::1		localhost\n127.0.1.1	archlinux.localdomain	archlinux" >>/etc/hosts
		;;
		10)
		timedatectl set-ntp true
		ln -sf /usr/share/zoneinfo/Africa/Algiers /etc/localtime
		hwclock --systohc
		locale-gen
		;;
		11)
		echo -e "LANG=fr_FR.UTF-8\nLC_COLLATE=C" >/etc/locale.conf
		;;
		12)
		mkinitcpio -p linux
		;;
		13)
		pacman -S --noconfirm grub
		grub-install /dev/sda
		grub-mkconfig -o /boot/grub/grub.cfg
		;;
		14)
		echo "please enter root password"
		sleep 0.5
		passwd
		;;
		e)
		break
		clear
		exit
	esac

done

