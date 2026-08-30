#!/bin/bash

set -ouex pipefail

cp -avf "/ctx/system_files"/. /

dnf5 -y remove plasma-workspace plasma-* kde-*
dnf5 -y copr enable zhangyi6324/noctalia-shell

dnf5 -y install 				    \
	niri						          \
	gnome-keyring				      \
	dolphin						        \
	xwayland-satellite		    \
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


if ! dnf5 -y install ghostty; then
	echo "Warning: ghostty unavailable, continuing without it."
fi

if ! dnf5 -y install noctalia-shell; then
	echo "Warning: noctalia-shell unavailable due to repo/dependency state, continuing without it."
fi


systemctl enable podman.socket
systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service plasma-polkit-agent.service