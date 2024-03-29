#!/bin/bash

# Tell Linux that the system time is local, not UTC, so that rebooting and changing OSes doesn't butcher the time
# See: https://itsfoss.com/wrong-time-dual-boot/
sudo timedatectl set-local-rtc 1

# Refresh mirrors, existing ones may be out of date, 404ing and slowing everything down
sudo pacman-mirrors
# Now, update keyring things and stuff that will cause upgrading to fail
sudo pacman-key --refresh-keys
# Initialize pacman and upgrade everything
sudo pacman -Syu

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
sudo pacman -R thunderbird qbittorrent

### Install stuff.
# Enable AUR (needed for steamcmd - Steam dev tools)
sudo sed --in-place "s/#EnableAUR/EnableAUR/" "/etc/pamac.conf"

# Unzip is needed for heroic, lol.
# xsane/xsane-gimp are for scanning.
sudo pacman -Sy godot gimp audacity lmms intellij-idea-community-edition unzip xsane xsane-gimp

# Lots of stuff needed for Heroic (Wine, specifically) to run games. Source: https://github.com/lutris/docs/blob/master/WineDependencies.md#archendeavourosmanjaroother-arch-derivatives
sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

# AUR stuff. TODO: MongoDB
pamac install steamcmd --no-confirm

# SMH. OBS from Flatpak since the pamac one is broken as of writing
sudo pacman -S flatpak         
sudo flatpak install flathub com.obsproject.Studio.flatpakref

# VSCode + C# doesn't work well with "code" (OSS version). The official version from Snap works, though.
echo ********** don't forget to enable Snapcraft support and install the official "code"! (Both are named code, herp derp)

### configure stuff
# git config
git config --global user.name nightblade9
git config --global user.email nightbladecodes@gmail.com

sudo shutdown -r 0
