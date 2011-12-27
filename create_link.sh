#!/bin/sh
cd $(dirname $0)
( ls -1 -A | egrep '^\.' | egrep -v '^(.git|.gitmodules|.gitignore)$' | while read dotfile; do
#    echo "if [ ! -e $HOME/$dotfile ]; then ln -fs \"$PWD/$dotfile\" $HOME; fi"
    echo "ln -fs \"$PWD/$dotfile\" $HOME"
done ) | sh > /dev/null
