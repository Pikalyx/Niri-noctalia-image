#!/bin/bash

set -ouex pipefail

cp -avf "/ctx/system_files"/. /

dnf5 -y remove plasma-workspace plasma-* kde-*

dnf5 config-manager setopt terra.enabled=1
dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

dnf5 -y install 				\
	niri						\
	ghostty						\
	gnome-keyring				\
	dolphin						\
	xwayland-satellite			\
	danklinux				\
	ark							\
	mako						\
	mpv							\
	unrar						\
	gdm							\
	xdg-desktop-portal-gtk		\
	xdg-desktop-portal-gnome	\
	cifs-utils					\
	kio-fuse					\
	kio-extras					\
	dolphin-plugins				\
	audiocd-kio					\
	kf5-kimageformats			\
	kdegraphics-thumbnailers	\
	ffmpegthumbs				\
	icoutils					\
	taglib						\
	cliphist					\
	ddcutil						\
	polkit-kde					\
	gnome-keyring






systemctl enable podman.socket
systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service plasma-polkit-agent.service