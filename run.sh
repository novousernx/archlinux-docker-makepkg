#!/bin/sh

set -e -u

# Update everything.
yay -Syu --noconfirm

# Make a copy so we never alter the original.
cp -r /pkg /tmp/pkg
cd /tmp/pkg

# Install (official repo + AUR) dependencies using yay. We avoid using makepkg -s since it is unable to install AUR dependencies.
yay -Sy --noconfirm \
    $(pacman --deptest $(source ./PKGBUILD && echo ${depends[@]} ${makedepends[@]}))

# Do the actual building.
makepkg -f

# Store the built package(s). Ensure permissions match the original PKGBUILD.
if [ -n "$EXPORT_PKG" ]; then
    sudo chown $(stat -c '%u:%g' /pkg/PKGBUILD) ./*pkg.tar*
    sudo mv ./*pkg.tar* /pkg
fi
