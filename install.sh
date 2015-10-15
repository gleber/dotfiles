#!/bin/sh

set -eu
# set -x

DRY=${DRY:-""}

DIR=$(dirname $(readlink -f $0))
cd $DIR

if ! [ "$DIR" = "$HOME/dotfiles" ]; then
  echo "dotfiles repo should be in $HOME/dotfiles"
  exit 1
fi

rr() {
  if [ -n "$DRY" ]; then
    echo ">>> Skipping $*"
    return 0
  fi
  echo ">>> Running $*"
  eval "$@"
}

exists() {
  return $(hash $1 2>/dev/null)
}

require() {
  if ! exists "$1"; then
    "!!! $1 is required, but could not be found!"
    exit 1
  else
    echo ">>> $1 is present"
  fi
}

APTGET=
if exists apt-get; then
    APTGET=$(which apt-get)
fi
NIXENV=
if exists nix-env; then
    NIXENV=$(which nix-env)
fi

nixinstall() {
  bin=$1
  pkg=${2:-$1}
  if ! exists "$bin"; then
    rr $NIXENV -f '\<nixpkgs\>' -i -A "$pkg"
  else
    echo ">>> Skipping installation of $bin (package $pkg)"
  fi
}

require git
require zsh
require curl

rr git submodule update --init --recursive 

if ! exists nix-env; then
  rr curl https://nixos.org/nix/install | sh
fi

nixinstall stow

hash -r

if [ -z "$NIX_PATH" ]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi

#if ! exists apt-get; then
#  sudo apt-get install xfonts-terminus xfonts-terminus-dos xfonts-terminus-oblique
#fi

rrstow() {
  if [ -n "$DRY" ]; then
    stow -n -vv "$@"
  else
    stow -vv "$@"
  fi
}

rrstow zsh
rrstow git

nixinstall mr
rrstow myrepos

nixinstall zile
rrstow zile

rrstow themes

nixinstall ag silver-searcher
nixinstall ghc haskellPackages.ghc

nixinstall compton
rrstow compton

if exists awesome; then
    rrstow xmodmap
    rrstow awesome
    rrstow xinit
fi

nixinstall emacs
rrstow emacs
