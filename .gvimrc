"----------------------------------------
"--
"-- .gvimrc for @xxxkurosukexxx
"-- http://twitter.com/xxxkurosukexxx
"--
"-- Ver. 2014/04/08
"--
"----------------------------------------

"--------------- guiから余計なものを排除 ---------------
" ツールバー
set guioptions-=T
" メニューバー
set guioptions-=m
" スクロールバー（左右）
set guioptions-=rL

"--------------- 表示 ---------------
" 256色表示
set t_Co=256
" font
"set guifont=VL\ Gothic:h9
set guifont=VL\ Gothic:h10
" ウィンドウサイズ
set columns=200
set lines=55

"--------------- スキーム ---------------
" https://github.com/tomasr/molokai
"colorscheme molokai
"let g:molokai_original = 1
"let g:rehash256 = 1
"set background=dark

" https://github.com/altercation/vim-colors-solarized
"set background=light
"colorscheme solarized
"let g:solarized_termcolors=256

" https://github.com/vim-scripts/github-theme
"colorscheme github

" https://github.com/cocopon/iceberg.vim
colorscheme iceberg
set background=light
set background=dark
