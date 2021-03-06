#!/usr/bin/env zsh
ssh-add -K ~/.ssh/private/boyacky_key
# -*- coding: utf-8-unix; sh-basic-offset: 2; -*-

stty -ixon
stty -istrip
#bindkey -e
#bindkey -v
#bindkey '^W' kill-region

HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=10000000

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history
# シェルのプロセスごとに履歴を共有
setopt share_history
# 履歴ファイルに時刻を記録
setopt extended_history
# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# 重複したヒストリは追加しない
setopt hist_ignore_all_dups
# incremental append
setopt inc_append_history

# ディレクトリ名だけで､ディレクトリの移動をする｡
setopt auto_cd
# cdのタイミングで自動的にpushd
setopt auto_pushd
setopt pushd_ignore_dups

# 補完の大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# fpath の追加
fpath=(~/.zfunctions/Completion ${fpath})
# unfunction して，autoload する
function reload_function() {
  local f
  f=($HOME/.zfunctions/Completion/*(.))
  unfunction $f:t 2> /dev/null
  autoload -U $f:t
}
# 補完設定
autoload -Uz compinit; compinit

# ファイルリスト補完でもlsと同様に色をつける｡
export LSCOLORS=GxFxCxdxBxegedabagacad
export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' group-name ''
zstyle ':completion:*:default' use-cache true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':compinstall' filename '/home/v-naruse/.zshrc'
zstyle ':completion:*:processes' command 'ps x'
# sudo でも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                                           /usr/sbin /usr/bin /sbin /bin

# 補完候補が複数ある時に、一覧表示
setopt auto_list
# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
setopt auto_menu
# ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob
# C-s, C-qを無効にする。
setopt NO_flow_control
# 8 ビット目を通すようになり、日本語のファイル名を表示可能
setopt print_eight_bit
# カッコの対応などを自動的に補完
setopt auto_param_keys
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# 最後がディレクトリ名で終わっている場合末尾の / を自動的に取り除く
setopt auto_remove_slash
# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
# コマンドのスペルチェックをする
setopt correct
# =command を command のパス名に展開する
setopt equals
# シェルが終了しても裏ジョブに HUP シグナルを送らないようにする
setopt NO_hup
# Ctrl+D では終了しないようになる（exit, logout などを使う）
#setopt ignore_eof
# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示しない
setopt list_types
# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
# 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
setopt multios
# ファイル名の展開で、辞書順ではなく数値的にソートされるようになる
setopt numeric_glob_sort
# for, repeat, select, if, function などで簡略文法が使えるようになる
setopt short_loops
#コピペの時rpromptを非表示する
setopt transient_rprompt
# 文字列末尾に改行コードが無い場合でも表示する
unsetopt promptcr
# リダイレクトでファイルを消さない
setopt no_clobber
setopt notify
setopt print_exit_value

# 状態変数
local os='unknown'
local uname_s=`uname -s`
if [[ $uname_s == "Darwin" ]]; then
  os='mac'
elif [[ $uname_s == "SunOS" ]]; then
  os='sun'
elif [[ $uname_s == "FreeBSD" ]]; then
  os='bsd'
elif [[ $uname_s == "Linux" ]]; then
  os='lin'
fi
[ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`

# ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}[$branch_name] "
}

# すごいプロンプト
setopt prompt_subst
autoload -U colors; colors

if [[ $ZSH_VERSION == 5.*.* ]]; then
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' formats '(%s)-[%b]'
  zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
  precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  }
fi

if [[ x"$TERM" == x"dumb" || x"$TERM" == x"sun" || x"$TERM" == x"emacs" ]]; then
  use_color=
else
  use_color='true'
fi

if [[ x"$use_color" != x"true" ]]; then
  PROMPT='%U%B%n@%m%b %h %#%u '
  RPROMPT=
else
  local prompt_color='%{[32m%}'
  local clear_color='%{[0m%}'
  local rprompt_color='%{[33m%}' # yellow [0m
  local vcs_prompot_color='%{[32m%}' # green [0m
  local prompt_char='$'
  if [[ x"$USER" == x"yamaoka" ]]; then
    prompt_color='%{[32m%}'      # green [0m
  elif [[ x"$USER" == x"root" ]]; then
    prompt_color='%{[35m%}'      # pink [0m
    prompt_char='#'
  else
    prompt_color='%{[37m%}'      # white [0m
  fi
  PROMPT=$prompt_color'%U%B%n'$rprompt_color'%U@'$prompt_color'%B%m%b %h '$prompt_char$clear_color'%u '
  RPROMPT=$vcs_prompot_color'%1(v|%1v|) '$rprompt_color'[%~]''`rprompt-git-current-branch`'$clear_color
fi

if whence -p lv 2>&1 > /dev/null; then
  if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
    alias lv='command lv -Ou'
  fi
  export PAGER='lv -Ou'
  alias lc='lv | cat'
fi

# default path
export PATH=/usr/bin:/bin:/usr/local/bin:/Users/yamaoka/Develop/android-sdk-macosx/platform-tools:

# for Mac ports
if [[ $os == 'mac' ]]; then
  export LC_ALL=ja_JP.UTF-8
  export PATH="/opt/local/bin:/opt/local/sbin:${PATH}"
  export MANPATH="/opt/local/share/man:${MANPATH}"
fi
# for BSDPAN and local path
if [[ $os == 'bsd' ]]; then
  export PATH="${PATH}:/usr/local/bin:/usr/local/sbin"
  export MANPATH="${MANPATH}:/usr/local/share/man:/usr/local/man"
  export PKG_DBDIR=$HOME/local/var/db/pkg
  export PORT_DBDIR=$HOME/local/var/db/pkg
  export INSTALL_AS_USER
  export LD_LIBRARY_PATH=$HOME/local/lib
fi
# for csw
if [[ $os == 'sun' && -d /opt/csw/bin ]]; then
  export PATH="/opt/csw/bin:$PATH"
fi

# for local::lib
local_lib_path="$HOME/perl5"
function _set_perl_env () {
  export MODULEBUILDRC="${local_lib_path}/.modulebuildrc"
  export PERL_MM_OPT="INSTALL_BASE=${local_lib_path}"
  export PERL5LIB="${local_lib_path}/lib/perl5:${local_lib_path}/lib/perl5/$site"
  export PATH="${local_lib_path}/bin:$PATH"
}
if [[ "x$HOSTNAME" == "xdv1" ]]; then
  function set_perl_env () {
    local site='i486-linux-gnu-thread-multi'
    _set_perl_env
  }
  set_perl_env
elif [[ $os == 'mac' ]]; then
  function set_perl_env () {
    local site='darwin-multi-2level'
    _set_perl_env
  }
  function set_perl_env_wx () {
    local site='darwin-thread-multi-2level'
    _set_perl_env
  }
  set_perl_env
elif [[ $os == 'bsd' ]]; then
  function set_perl_env () {
    local site='i386-freebsd-64int'
    _set_perl_env
  }
  set_perl_env
fi

# for cabal
if [[ -d $HOME/.cabal/bin ]]; then
  export PATH="${PATH}:$HOME/.cabal/bin"
fi

export PATH="$HOME/local/bin:${PATH}"
export MANPATH="$HOME/local/man:${MANPATH}"
# for gems
if [[ -d /var/lib/gems/1.8/bin ]]; then
  export PATH="${PATH}:/var/lib/gems/1.8/bin"
fi
# for sbin
if [[ $PATH != "*:/sbin:*" && -d "/sbin" ]];then
  export PATH="${PATH}:/sbin"
fi
if [[ $PATH != "*:/usr/sbin:*" && -d "/usr/sbin" ]];then
  export PATH="${PATH}:/usr/sbin"
fi
# for gisty
export GISTY_DIR="$HOME/work/gists"

# for perl Devel::Cover
alias cover='cover -test -ignore "^inc/"'
# for perl Test::Pod::Coverage
export TEST_POD=1
# for perldoc
if [[ $os == 'mac' ]]; then
  alias perldoc='perldoc -t'
fi
# for scaladoc
export SCALA_DOC_HOME=/Users/s_nag/s/app/InteractiveHelp/scala-2.7.5-apidocs-fixed/

# ignore mailcheck
export MAILCHECK=0

# alias
alias mv='nocorrect mv -i'
alias cp='nocorrect cp -ip'
alias ln='nocorrect ln'
alias mkdir='nocorrect mkdir'
alias mgdir='nocorrect mkdir -m 775'
alias rm='rm -i'
alias history='builtin history -Di'
alias his='history | tail'
alias tmux='tmux -u'
alias pwgen='pwgen -Bs'
alias sl='ls'
alias ln='ln -n'
alias first_release="perl -mModule::CoreList -le 'print Module::CoreList->first_release(@ARGV)'"
alias screen='command screen -U'
alias grep='grep --color'
alias egrep='egrep --color'
alias vi=vim

alias delds='sudo find / -name ".DS_Store" -delete'
alias sock_proxy='sh /Users/yamaoka/.dotfiles/proxy.sh'
alias sock_proxy_state='sh /Users/yamaoka/.dotfiles/check_proxy.sh'

if [[ $use_color == 'true' ]]; then
  if [[ $os == 'mac' || $os == 'bsd' ]]; then
    alias ls='command ls -AFG'
    #alias ls='command ls -G'
  elif [[ $os == 'sun' ]]; then
    alias ls='command ls -AF'
    #alias ls='command ls'
  else
    alias ls='command ls -AF --color=auto --show-control-chars'
    #alias ls='command ls --color=auto --show-control-chars'
  fi
else
  alias ls='command ls -AF'
  #alias ls='command ls'
fi
if [[ $os == 'mac' ]]; then
  alias emacs-app='/opt/local/var/macports/software/emacs-app/23.1_1/Applications/MacPorts/Emacs.app/Contents/MacOS/Emacs'
  alias emacsclient='/opt/local/var/macports/software/emacs-app/23.1_1/Applications/MacPorts/Emacs.app/Contents/MacOS/bin/emacsclient'
  alias javac='javac -J-Dfile.encoding=UTF-8 -Xlint:unchecked -Xlint:deprecation'
  alias java='java -Dfile.encoding=UTF8'
  alias mvim='/Applications/MacVim.app/Contents/MacOS/Vim'
  export ANT_OPTS='-Dfile.encoding=UTF-8'
fi

# 補完するかの質問は画面を超える時にのみに行う｡
LISTMAX=0

# Ctrl+wで､直前の/までを削除する｡
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# href の補完
compctl -K _href href
functions _href () {
  local href_datadir=`href_datadir`
  reply=(`cat $href_datadir/comptable|awk -F, '{print $2}'|sort|uniq`)
  # /usr/share/href/comptable の Path は自分の環境に書き換える
}

# keychain
if whence -p keychain 2>&1 > /dev/null; then
  keychain id_rsa
  if [ -f $HOME/.keychain/$HOSTNAME-sh ]; then
    . $HOME/.keychain/$HOSTNAME-sh
  fi
  if [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]; then
    . $HOME/.keychain/$HOSTNAME-sh-gpg
  fi
fi

function changetitle {
  # pwdを二回も実行しているのがなんかダサい...
  current_dir=`pwd | sed -e "s%\(/\([^.]\|\..\)\)[^/]*%\1%g"``pwd | sed -e "s%^.*/\([^.]\|\..\)\([^/]*\)$%\2%"`
  # タイトル用に整形
  title=[${HOST%%.*}]
  case "${TERM}" in
    xterm*|kterm*|rxvt*)
      echo -ne "\033]0;${title}\007"
    ;;
    screen*)
      echo -ne "\033P\033]0;${title}\007\033\\"
    ;;
  esac
}

# zsh起動時にとりあえず実行
changetitle

# cd実行後に変更
function chpwd() {
  changetitle
}

# Screenの場合、window切り替え時に前のwindowのタイトルがTerminal(＆タブ)のタイトルとして
# 残ってしまうのでせめてcdコマンド以外のコマンドでも実行前にタイトルを変更
preexec () {
  changetitle

  #screen のタイトルを最終実行コマンドに変更
  [ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/Users/yamaoka/Library/Android/sdk/platform-tools/:$PATH"
