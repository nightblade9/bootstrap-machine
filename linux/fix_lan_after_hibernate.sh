#!/bin/sh
# After hibernation, Wifi works, but the LAN connection doesn't. You can read all about it here:
# https://forum.manjaro.org/t/no-internet-available-after-hibernation/109089/33
# Nah, just kidding. There's no solution there.

# This seems to work, though; courtesy of https://bbs.archlinux.org/viewtopic.php?id=234725
# Uninstalls and reinstalls the kernel driver.

sudo modprobe -r r8169 ath10k_pci
sleep(5)
sudo modprobe r8169 ath10k_pci
