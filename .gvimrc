"----------------------------------------
"--
"-- .gvimrc for @xxxkurosukexxx
"-- http://twitter.com/xxxkurosukexxx
"--
"-- Ver. 2014/02/18
"--
"----------------------------------------

"--------------- guiから余計なものを排除 ---------------
" ツールバー
set guioptions-=T
" メニューバー
set guioptions-=m
" スクロールバー（右）
set guioptions-=r

"--------------- 表示 ---------------
" 256色表示
set t_Co=256
" font
set guifont=VL\ Gothic:h10
" ウィンドウサイズ
set columns=140
set lines=55

"--------------- スキーム ---------------
" https://github.com/tomasr/molokai
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
set background=dark

