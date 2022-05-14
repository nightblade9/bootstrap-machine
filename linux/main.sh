#!/bin/bash

# Tell Linux that the system time is local, not UTC, so that rebooting and changing OSes doesn't butcher the time
# See: https://itsfoss.com/wrong-time-dual-boot/
sudo timedatectl set-local-rtc 1

# Initialize pacman and upgrade everything
sudo pacman -Sy

# Remove cruft
sudo pacman -R thunderbird

# Upgrade everything
pacman -Syu

### Get and build wifi driver
# pretend we have the 5.15.32 drivers, we have 5.15.38
sudo ln -s /usr/lib/modules/5.15.38-1-MANJARO /usr/lib/modules/5.15.32-1-MANJARO

cd /tmp
git clone https://github.com/brektrou/rtl8821CU
cd rtl8821CU
uname -r
echo note the major and minor version  number, e.g. 5.15 means install headers-515
sudo pacman -S linux515-headers
sudo pacman -S dkms 
sudo ./dkms-install.sh

# Add a swap file for hibernation. Assumes 16GB RAM. See: https://wiki.manjaro.org/index.php/Swap/en
# This also enables hibernation. (Previous versions of Manjaro required additional steps.)
sudo dd if=/dev/zero of=/swapfile bs=1M count=20480 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"

### TODO: automate this to get hibernate to work on resume
findmnt -no UUID -T /swapfile # gives the hibernation device UUID
sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}' # gives the offset
# Run sudo vi /etc/default/grub and append this (with the values above) to GRUB_CMDLINE_LINUX_DEFAULT: resume=UUID=<uuid> resume_offset=<offset>

sudo mkinitcpio -P
sudo update-grub

# Blacklisting bad wifi doesn't work; disable it on startup
echo sudo modprobe -r r8169 >>~/.bashrc

# Done. Install everything we need.
sudo pacman -S code godot gimp audacity lmms git-lfs
git lfs install
# git config
git config --global user.name nightblade9
git config --global user.email nightbladecodes@gmail.com

sudo shutdown -r 0
