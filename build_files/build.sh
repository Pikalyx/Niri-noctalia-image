#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 -y install niri cava qt6-qtmultimedia cargo rust kde-connect gdm

dnf5 -y copr enable avengemedia/dms
dnf5 -y install dms
dnf5 -y copr disable avengemedia/dms

dnf5 -y copr enable avengemedia/danklinux
dnf5 -y install dsearch matugen dgop ghostty
dnf5 -y copr disable avengemedia/danklinux

# Ensure the graphical login manager is enabled so the user reaches a desktop
if [ -L /etc/systemd/system/display-manager.service ] && \
   [ "$(readlink /etc/systemd/system/display-manager.service)" != "/usr/lib/systemd/system/gdm.service" ]; then
  rm -f /etc/systemd/system/display-manager.service
fi
ln -s /usr/lib/systemd/system/gdm.service /etc/systemd/system/display-manager.service

# Start the companion user services for the desktop session
# Start companion user services only if their units really exist
if systemctl --global list-unit-files dms.service >/dev/null 2>&1; then
    systemctl --global add-wants graphical-session.target dms.service || true
fi

if systemctl --global list-unit-files dsearch.service >/dev/null 2>&1; then
    systemctl --global add-wants graphical-session.target dsearch.service || true
fi