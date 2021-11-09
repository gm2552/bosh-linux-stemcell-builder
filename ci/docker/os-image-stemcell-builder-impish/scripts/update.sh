#!/bin/bash

set -ex

cat > /etc/apt/sources.list <<EOS
deb http://us.archive.ubuntu.com/ubuntu/ impish main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ impish main restricted

deb http://us.archive.ubuntu.com/ubuntu/ impish-updates main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ impish-updates main restricted

deb http://security.ubuntu.com/ubuntu impish-security main restricted
deb-src http://security.ubuntu.com/ubuntu impish-security main restricted
deb http://security.ubuntu.com/ubuntu impish-security universe
deb-src http://security.ubuntu.com/ubuntu impish-security universe
deb http://security.ubuntu.com/ubuntu impish-security multiverse
deb-src http://security.ubuntu.com/ubuntu impish-security multiverse

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://us.archive.ubuntu.com/ubuntu/ impish universe
deb-src http://us.archive.ubuntu.com/ubuntu/ impish universe
deb http://us.archive.ubuntu.com/ubuntu/ impish-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ impish-updates universe
deb http://us.archive.ubuntu.com/ubuntu/ impish multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ impish multiverse
deb http://us.archive.ubuntu.com/ubuntu/ impish-updates multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ impish-updates multiverse
EOS

apt-get update
apt-get -y upgrade; apt-get clean
export DEBIAN_FRONTEND=noninteractive

apt-get -y  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -y install curl

# sometimes the cached lists seem to get out of date around here
# http://askubuntu.com/questions/41605/trouble-downloading-packages-list-due-to-a-hash-sum-mismatch-error/160179
rm -rf /var/lib/apt/lists/*

apt-get -y update --fix-missing
apt-get -y install git
apt-get -y install build-essential

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-generic

# stemcell image creation
apt-get -y install debootstrap kpartx

# stemcell uploading
apt-get -y install s3cmd

# native gem compilation
apt-get -y install g++ git-core make

# native gem dependencies
apt-get -y install libmysqlclient-dev libpq-dev libsqlite3-dev libxml2-dev libxslt-dev

# vSphere requirements
apt-get -y install open-vm-tools

# OpenStack requirement
apt-get -y install qemu-utils

# needed by stemcell building
apt-get -y install parted

mkdir -p /mnt/tmp
chown -R ubuntu:ubuntu /mnt/tmp
echo 'export TMPDIR=/mnt/tmp' >> ~ubuntu/.bashrc

# rake tasks will be using this as chroot
mkdir -p /mnt/stemcells
chown -R ubuntu:ubuntu /mnt/stemcells
