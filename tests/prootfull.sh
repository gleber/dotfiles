#!/bin/sh

./install.sh

source $HOME/.nix-profile/etc/profile.d/nix.sh
./uninstall.sh
