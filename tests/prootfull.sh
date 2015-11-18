#!/bin/sh

set -eux

./tests/replace-private.sh
./install.sh
. $HOME/.nix-profile/etc/profile.d/nix.sh
./uninstall.sh
