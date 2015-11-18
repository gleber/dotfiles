#!/bin/bash

set -e
set -u

for f in $(cat $HOME/dotfiles/.gitattributes | grep git-crypt | awk "{print \$1}"); do
    fake=${f%.private}.anonymized
    cp $fake $f || true
done

echo > $HOME/dotfiles/.gitattributes
