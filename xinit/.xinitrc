#!/bin/bash

xrdb -merge ~/.Xresources
xmodmap ~/.xmodmap

urxvd -q -f -o &
compton -b --config ~/.config/compton.conf &

exec awesome
