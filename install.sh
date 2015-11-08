#!/bin/sh

DIR=$(dirname $(readlink -f $0))
cd $DIR

set -eu
# set -x

. ${DIR}/common.sh

require zsh
require curl

if [ ! -d /nix/store ]; then
    echo "Installing nix..."
    curl https://nixos.org/nix/install | sh
fi

case "$PATH" in
    *nix-profile*)
        ;;
    *)
        . ~/.nix-profile/etc/profile.d/nix.sh
        ;;
esac

NIXENV=$(which nix-env)

KEYS=$HOME/.ssh/authorized_keys
mkdir -p $(dirname $KEYS)
touch $KEYS
chmod 0600 $KEYS

(
    echo "\n# Further keys are taken from github.com/gleber.keys on $(date)"
    curl https://github.com/gleber.keys | grep -v -x -f $KEYS || true
) >> $HOME/.ssh/authorized_keys

nixinstall git gitAndTools.gitFull
nixinstall stow
nixinstall mr
rrstow myrepos

mr checkout

hash -r

# Config basics

rrstow zsh
rrstow git
rrstow bin

# Config my ad-hoc editor

nixinstall zile
rrstow zile

rrstow themes

# Config haskell development

nixinstall ag silver-searcher
nixinstall ghc haskellPackages.ghc
nixinstall cabal haskellPackages.cabal-install
nixinstall ghc-mod haskellPackages.ghc-mod
nixinstall hlint haskellPackages.hlint
nixinstall structured-haskell-mode haskellPackages.structured-haskell-mode
nixinstall stylish-haskell haskellPackages.stylish-haskell
nixinstall hindent haskellPackages.hindent
nixinstall hasktags haskellPackages.hasktags

rrstow stack
nixinstall stack haskellPackages.stack

# Configure my windowing environment

if exists X; then
    nixinstall compton
    rrstow compton
    rrstow xmodmap
    nixinstall parcellite
    rrstow parcellite
    nixinstall xwininfo byzanz
    rrstow awesome
    rrstow xinit
fi

# Configure emacs + spacemacs

nixinstall emacs
rrstow emacs

# Configure keybase

nixinstall gpg2 gnupg
nixinstall keybase keybase

hash -r
