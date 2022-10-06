#!/bin/bash

# Tell Linux that the system time is local, not UTC, so that rebooting and changing OSes doesn't butcher the time
# See: https://itsfoss.com/wrong-time-dual-boot/
sudo timedatectl set-local-rtc 1

# Disable flaky wifi on startup! And probably on hibernate.
echo blacklist ath10k_pci | sudo tee -a /etc/modprobe.d/blacklist.conf

# Initialize pacman and upgrade everything
sudo pacman -Sy

### Enable hibernate
# Add a swap file for hibernation. Assumes 16GB RAM. See: https://wiki.manjaro.org/index.php/Swap/en
# This also enables hibernation. (Previous versions of Manjaro required additional steps.)
sudo dd if=/dev/zero of=/swapfile bs=1M count=20480 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"

### TODO: automate this to get hibernate to work on resume
# 1) get the UUID and offset
findmnt -no UUID -T /swapfile # gives the hibernation device UUID
sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}' # gives the offset

# 2) Run sudo vi /etc/default/grub and append this (with the values above) to GRUB_CMDLINE_LINUX_DEFAULT: resume=UUID=<uuid> resume_offset=<offset>
# 3) Then: sudo vi /etc/mkinitcpio.conf. Look for HOOKS=(...) and add "resume" (no quotes) in there before fsck

# Rebuild config
sudo mkinitcpio -P
sudo update-grub
### Done. Restart to enable hibernate.

# Remove cruft
sudo pacman -R thunderbird

# Upgrade everything
sudo pacman -Syu

### Install stuff.
# Enable AUR (needed for steamcmd - Steam dev tools)
sudo sed --in-place "s/#EnableAUR/EnableAUR/" "/etc/pamac.conf"

sudo pacman -Sy code godot gimp audacity lmms intellij-idea-community-edition postgresql 

# AUR stuff. TODO: MongoDB
pamac install steamcmd --no-confirm

### configure stuff
# git config
git config --global user.name nightblade9
git config --global user.email nightbladecodes@gmail.com

sudo shutdown -r 0
