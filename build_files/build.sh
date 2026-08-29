#!/bin/bash

set -ouex pipefail

cp -avf "/ctx/system_files"/. /

dnf5 -y remove plasma-workspace plasma-* kde-*
dnf5 -y copr enable sneexy/zen-browser
dnf5 -y copr enable zhangyi6324/noctalia-shell

dnf5 -y install 				    \
	niri						          \
	ghostty						        \
	gnome-keyring				      \
	dolphin						        \
	xwayland-satellite		    \
	noctalia-shell				    \
	ark							          \
	mako						          \
	mpv							          \
	unrar						          \
	gdm							          \
	xdg-desktop-portal-gtk		\
	xdg-desktop-portal-gnome	\
	cifs-utils					      \
	kio-fuse					        \
	kio-extras					      \
	dolphin-plugins				    \
	audiocd-kio					      \
	kf5-kimageformats			    \
	kdegraphics-thumbnailers	\
	ffmpegthumbs				      \
	icoutils					        \
	taglib						        \
	cliphist					        \
	ddcutil						        \
	polkit-kde

if ! dnf5 -y install zen-browser; then
	echo "Warning: zen-browser unavailable, continuing without it."
fi


systemctl enable podman.socket
systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service plasma-polkit-agent.service