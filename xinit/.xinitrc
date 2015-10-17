#!/bin/bash

# For this file to work, make sure it is linked as .xinitrc, .xsession
$ and .xessionrc

xrdb -merge ~/.Xresources
xmodmap ~/.xmodmap

urxvd -q -f -o &
compton -b --config ~/.config/compton.conf &

(sleep 2 && nm-applet) &
(sleep 3 && parcellite) &

exec awesome
