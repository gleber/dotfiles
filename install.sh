#!/bin/bash

set -eu
# set -x

DRY=${DRY:-""}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $DIR

if ! [[ "$DIR" == "$HOME/dotfiles" ]]; then
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

nix-install() {
  bin=$1
  pkg=${2:-$1}
  if ! exists "$bin"; then
    rr nix-env -f '\<nixpkgs\>' -i -A "$pkg"
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

nix-install stow
nix-install zile

hash -r

if [[ -z "$NIX_PATH" ]]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi

rrstow() {
  if [ -n "$DRY" ]; then
    stow -n -vv "$@"
  else
    stow -vv "$@"
  fi
}

rrstow zsh
rrstow git
rrstow zile
rrstow themes

nix-install ag silver-searcher
nix-install emacs
nix-install ghc haskellPackages.ghc
