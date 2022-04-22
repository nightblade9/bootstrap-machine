#!/bin/bash

# Install *everything!* Assumes you're on Arch/Manjaro.
su root
sudo pacman -S code godot gimp audacity lmms git-lfs
exit

# Add a swap file for hibernation. Assumes 16GB RAM. See: https://wiki.manjaro.org/index.php/Swap/en
# This also enables hibernation. (Previous versions of Manjaro required additional steps.)
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
