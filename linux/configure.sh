#!/bin/bash
# Add a swap file for hibernation. Assumes 16GB RAM. See: https://wiki.manjaro.org/index.php/Swap/en
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"

echo Enable hibernation manually! Requires parsing blkid! 
echo Follow these steps: https://confluence.jaytaala.com/display/TKB/Use+a+swap+file+and+enable+hibernation+on+Arch+Linux+-+including+on+a+LUKS+root+partition
