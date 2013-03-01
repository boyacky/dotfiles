"vunlde.vimで管理してるpluginを読み込む
source ~/.dotfiles/.vimrcs/.vimrc.bundle
"基本設定
source ~/.dotfiles/.vimrcs/.vimrc.basic
"表示関連 Color関連
source ~/.dotfiles/.vimrcs/.vimrc.apperance
"エンコーディング関連
source ~/.dotfiles/.vimrcs/.vimrc.encoding
"編集関連
source ~/.dotfiles/.vimrcs/.vimrc.editing
"プラグインに依存する設定
source ~/.dotfiles/.vimrcs/.vimrc.plugins_setting

" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction"}}}
