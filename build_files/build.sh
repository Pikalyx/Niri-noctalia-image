#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 -y install niri cava qt6-qtmultimedia cargo rust kde-connect greetd

# The Bazzite base includes the GNOME compositor and greeter; remove them from
# this image so the desktop session is provided by Niri and greetd.
dnf5 -y remove gdm gnome-shell mutter

dnf5 -y copr enable avengemedia/dms
dnf5 -y install dms
dnf5 -y copr disable avengemedia/dms

dnf5 -y copr enable avengemedia/danklinux
dnf5 -y install dsearch matugen dgop ghostty
dnf5 -y copr disable avengemedia/danklinux

# Use greetd as the Niri-native login manager instead of GDM.
if [ -L /etc/systemd/system/display-manager.service ] && \
   [ "$(readlink /etc/systemd/system/display-manager.service)" != "/usr/lib/systemd/system/greetd.service" ]; then
  rm -f /etc/systemd/system/display-manager.service
fi
ln -s /usr/lib/systemd/system/greetd.service /etc/systemd/system/display-manager.service
systemctl enable greetd.service
