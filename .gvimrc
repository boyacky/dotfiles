if has('gui_macvim')
  colorscheme koehler          " カラースキーマ
  set showtabline=2            " タブを常に表示
  set imdisable                " IME OFF
  set guioptions-=T            " ツールバー非表示
  set antialias                " アンチエイリアス
  set tabstop=4                " タブサイズ
  set visualbell t_vb=         " ビープ音なし
  set nowrapscan               " 検索をファイルの先頭へループしない
  set transparency=20          " 透明度を指定
  set guifont=Ricty:h13        " フォント指定
  set lines=50 columns=150     " ウィンドウサイズをセット はみだした部分は自動的に修正させて画面いっぱいに表示させる
endif

"表示系
set textwidth=0
set backspace=indent,eol,start
set nowrap
set tabstop=2
set expandtab
set shiftwidth=4
set shiftround
set matchpairs+=<:>
set foldmethod=marker
set nonumber
set softtabstop=2
set virtualedit=all

"移動系
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

inoremap <c-h> <Left>
inoremap <c-j> <Down>
inoremap <c-k> <Up>
inoremap <c-l> <Right>
inoremap <c-d> <Del>

"引用符のセット入力時に一文字左に戻す
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>

"コマンドの入力状況の表示
set showcmd
" バックアップなし
set nobackup
" 履歴ファイルを作らない
set noundofile

" 文字コード関連
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,utf-16,japan
set fileformats=unix,dos,mac
