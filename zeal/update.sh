#!/usr/bin/env zsh

set -eu

cd .docsets

local -a BASE_LIST

BASE_LIST=(Bash C++ Elixir "Emacs Lisp" Erlang Haskell "Python 2" "Python 3")
CURRENT_LIST=("${(f)$(ls -1d *.docset | sed 's#\.docset##g')}")

LIST=( $BASE_LIST $CURRENT_LIST )

for i in $LIST; do
    echo "LIST>" $i "<"
done

rm -rf *.docset || true

for n in $LIST; do
    nn=${n// /_}
    if [ -d "${n}.docset" -o -d "${nn}.docset" ]; then
        continue
    fi
    echo $n
    wget http://sanfrancisco.kapeli.com/feeds/${nn}.tgz
    tar xfvz ${nn}.tgz
    rm ${nn}.tgz
done
