# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
export SVN_EDITOR="vi"
export PS1='[\u@\h:\w]\n $ '

if [[ -x $HOME/local/bin/zsh ]]; then
  SHELL=$HOME/local/bin/zsh
  exec $SHELL
elif [[ -x /usr/local/bin/zsh ]]; then
  SHELL=/usr/local/bin/zsh
  exec $SHELL
elif [[ -x /bin/zsh ]]; then
  SHELL=/bin/zsh
  exec $SHELL
fi
