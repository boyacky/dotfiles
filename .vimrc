" .vim/bundle/plugin_nameを読み込むようにする
call pathogen#runtime_append_all_bundles()
" .vim/bunle/plugin_nameのヘルプを読み込めるようにする
call pathogen#helptags()
" phpmanual読み込み
let g:ref_phpmanual_path = $HOME . '/.dotfiles/phpmanual'
" 入力補完
let g:neocomplcache_enable_at_startup = 1

set smartindent
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
set nowrapscan

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

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

"引用符のセット入力時に一文字左に戻す
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>

" {{{コマンドの入力状況の表示
set showcmd

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,utf-16,japan
set fileformats=unix,dos,mac
"}}}

"{{{文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
"}}}

"{{{ 改行コードの自動認識
set fileformats=unix,dos,mac
"}}

