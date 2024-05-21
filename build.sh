#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1
curl -L https://raw.githubusercontent.com/coreos/fedora-coreos-config/testing-devel/fedora-coreos-pool.repo -o /etc/yum.repos.d/fedora-coreos-pool.repo
# this installs a package from fedora repos
rpm-ostree override remove nfs-utils-coreos
rpm-ostree install open-vm-tools qemu-guest-agent pciutils pcp-zeroconf samba usbutils wget glances libvirt-client libvirt-daemon-kvm virt-install cockpit-system cockpit-ostree cockpit-podman cockpit-networkmanager cockpit-storaged cockpit-machines cockpit-selinux caddy git

git clone https://github.com/45drives/cockpit-zfs-manager.git
cp -r cockpit-zfs-manager/zfs /usr/share/cockpit
rm -rf cockpit-zfs-manager
mkdir /etc/caddy
wget https://raw.githubusercontent.com/neliets/kzgb/main/Caddyfile -O /etc/caddy/Caddyfile

#### Example for enabling a System Unit File
systemctl enable podman.socket
systemctl enable cockpit.service
systemctl enable rpm-ostreed-automatic.timer
systemctl enable getty@tty1
rm /etc/ssh/sshd_config.d/40-disable-passwords.conf
cp -a /etc/firewalld/firewalld-server.conf /etc/firewalld/firewalld.conf
