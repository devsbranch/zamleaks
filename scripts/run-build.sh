#!/bin/bash

# set -e

# LOGFILE="/var/globaleaks/log/globaleaks.log"
# ACCESSLOG="/var/globaleaks/log/access.log"

# function atexit {
#   if [[ -f $LOGFILE ]]; then
#     cat $LOGFILE
#   fi

#   if [[ -f $ACCESSLOG ]]; then
#     cat $ACCESSLOG
#   fi
# }

# trap atexit EXIT

# apt-get install -y debootstrap

# # export chroot="/tmp/globaleaks_chroot"
# export chroot="/var/globaleaks"
# # mkdir -p "$chroot/build"
# # cp -R  $GITHUB_WORKSPACE/ "$chroot/build"

# export LC_ALL=en_US.utf8
# export DEBIAN_FRONTEND=noninteractive
# ls "/var/globaleaks" -al
# debootstrap --arch=amd64 bookworm "build/" http://deb.debian.org/debian/
# echo "deb http://deb.debian.org/debian bookworm main contrib" > /etc/apt/sources.list
# echo "deb http://deb.debian.org/debian bookworm main contrib" >> /etc/apt/sources.list
# # mount --rbind /proc "build/proc"
# # mount --rbind /sys "build/sys"
# apt-get update -y
# # apt-get upgrade -y
# chroot "$chroot" apt-get install -y lsb-release locales sudo
# echo "en_US.UTF-8 UTF-8" >> /tmp/globaleaks_chroot/etc/locale.gen

# chroot "$chroot" locale-gen
# chroot "$chroot" useradd -m builduser
# chroot "$chroot" useradd -m globaleaks

# echo "builduser ALL=NOPASSWD: ALL" >> "$chroot"/etc/sudoers
# echo "globaleaks ALL=NOPASSWD: ALL" >> "$chroot"/etc/sudoers
# chroot "$chroot" chown builduser -R /build
# chroot "$chroot" chown globaleaks -R /var/globaleaks

# ./scripts/build_and_install.sh
# =======




set -e

LOGFILE="/var/globaleaks/log/globaleaks.log"
ACCESSLOG="/var/globaleaks/log/access.log"

function atexit {
  if [[ -f $LOGFILE ]]; then
    cat $LOGFILE
  fi

  if [[ -f $ACCESSLOG ]]; then
    cat $ACCESSLOG
  fi
}

trap atexit EXIT

sudo apt-get install -y debootstrap

export chroot="/tmp/globaleaks_chroot/"
sudo mkdir -p "$chroot/build"
sudo cp -R  . "$chroot/build"
export LC_ALL=en_US.utf8
export DEBIAN_FRONTEND=noninteractive
sudo -E ls "$chroot/build" -al
sudo -E debootstrap --arch=amd64 bookworm "$chroot" http://deb.debian.org/debian/
sudo -E su -c 'echo "deb http://deb.debian.org/debian bookworm main contrib" > /tmp/globaleaks_chroot/etc/apt/sources.list'
sudo -E su -c 'echo "deb http://deb.debian.org/debian bookworm main contrib" >> /tmp/globaleaks_chroot/etc/apt/sources.list'
sudo -E mount --rbind /proc "$chroot/proc"
sudo -E mount --rbind /sys "$chroot/sys"
sudo -E chroot "$chroot" apt-get update -y
sudo -E chroot "$chroot" apt-get upgrade -y
sudo -E chroot "$chroot" apt-get install -y lsb-release locales sudo
sudo -E su -c 'echo "en_US.UTF-8 UTF-8" >> /tmp/globaleaks_chroot/etc/locale.gen'
sudo -E chroot "$chroot" locale-gen
sudo -E chroot "$chroot" useradd -m builduser
sudo -E su -c 'echo "builduser ALL=NOPASSWD: ALL" >> "$chroot"/etc/sudoers'
sudo -E chroot "$chroot" chown builduser -R /build
sudo -E chroot "$chroot" su - builduser /bin/bash -c '/build/GlobaLeaks/.github/workflows/scripts/build_and_install.sh'