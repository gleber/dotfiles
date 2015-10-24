#!/bin/sh

set -x

./install.sh

. $HOME/.nix-profile/etc/profile.d/nix.sh
./uninstall.sh
