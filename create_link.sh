#!/bin/sh
cd $(dirname $0)
( ls -1 -A | egrep '^\.' | egrep -v '^(.git|.gitmodules|.gitignore)$' | while read dotfile; do
    #ln -Fis "$PWD/$dotfile" $HOME
    echo "if [ ! -e $HOME/$dotfile ]; then ln -s \"$PWD/$dotfile\" $HOME; fi"
done ) | cat > /dev/null
#done ) | sh > /dev/null
