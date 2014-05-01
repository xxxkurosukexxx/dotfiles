"------------------------------------------
"--                                      --
"--     .gvimrc for @xxxkurosukexxx      --
"--  https://twitter.com/xxxkurosukexxx  --
"--                                      --
"-- Copyright (c) 2014 xxxkurosukexxx    --
"-- Released under the MIT license       --
"-- See LICENSE.txt                      --
"--                                      --
"--                      Ver. 2014/05/01 --
"--                                      --
"------------------------------------------

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
set guifont=VL\ Gothic:h9
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
