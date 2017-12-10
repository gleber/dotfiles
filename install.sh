#!/bin/sh

DIR=$(dirname $(readlink -f $0))
cd $DIR

set -eu

. ${DIR}/common.sh

require zsh
require curl

if [ ! -d /nix/store ] || [ ! -e $HOME/.nix-profile ] || [ ! -e $HOME/.nix-channels ]; then
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

require nix-env
require nix-shell

nixinstall stow

# Home-manager install
rr mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER
rrstow home-manager

if ! exists home-manager; then
    HMPATH=$(cat home-manager/.config/nixpkgs/home.nix | grep "home-manager.*release" | perl -pe 's#.*path.*(https?.*?);#\1#g')
    rr nix-shell $HMPATH -A install
fi

KEYS=$HOME/.ssh/authorized_keys
mkdir -p $(dirname $KEYS)
touch $KEYS
chmod 0600 $KEYS

(
    echo "\n# Further keys are taken from github.com/gleber.keys on $(date)"
    curl https://github.com/gleber.keys | grep -v -x -f $KEYS || true
) >> $HOME/.ssh/authorized_keys

exit

rrstow myrepos
mr checkout

hash -r

# Config basics

rrstow bin

# Config my ad-hoc editor

nixinstall zile
rrstow zile

rrstow themes

# Config erlang development
# It is highly experimental at the moment

if enabled erlang; then
    rrstow hex
    rrstow rebar
fi

# Config haskell development

if enabled haskell; then
    nixinstall ag silver-searcher
    nixinstall ghc haskellPackages.ghc
    nixinstall cabal haskellPackages.cabal-install
    nixinstall ghc-mod haskellPackages.ghc-mod
    nixinstall hlint haskellPackages.hlint
    # nixinstall structured-haskell-mode haskellPackages.structured-haskell-mode
    nixinstall stylish-haskell haskellPackages.stylish-haskell
    nixinstall hindent haskellPackages.hindent
    nixinstall hasktags haskellPackages.hasktags

    rrstow stack
    nixinstall stack haskellPackages.stack
fi

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
    nixinstall slock
fi

# Configure emacs + spacemacs

nixinstall w3m
nixinstall sqlite3 sqlite # required by helm-dash
nixinstall emacs
rrstow emacs

# Configure Zeal

nixinstall zeal
rrstow zeal
(
    cd zeal
    ./update.sh
)

# Configure cryptography

if enabled crypto; then
    nixinstall gpg2 gnupg
    nixinstall keybase nodejs-keybase
    nixinstall pass
    nixinstall qtpass
    nixinstall git-crypt gitAndTools.git-crypt
fi

# Fetch password-store

if enabled passwordstore; then
    if [ ! -d ~/.password-store ]; then
        PASSWORD_STORE_URL=$(cat private/password-store.private)
        git clone $PASSWORD_STORE_URL ~/.password-store
        pass git init
    fi
fi

hash -r

echo ">>> Installation finished successfully! <<<"
