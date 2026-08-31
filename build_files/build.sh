#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 -y install niri cava qt6-qtmultimedia cargo rust kde-connect

dnf5 -y copr enable avengemedia/dms
dnf5 -y install dms
dnf5 -y copr disable avengemedia/dms

dnf5 -y copr enable avengemedia/danklinux
dnf5 -y install dsearch matugen dgop ghostty
dnf5 -y copr disable avengemedia/danklinux

#### enabling a System Unit File

systemctl --global add-wants niri.service dms dsearch.service