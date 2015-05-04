"----------------------------------------------------
"--                                                --
"--           .vimrc for @xxxkurosukexxx           --
"--       https://twitter.com/xxxkurosukexxx       --
"--                                                --
"--      Copyright (c) 2014 xxxkurosukexxx         --
"--      Released under the MIT license            --
"--      See LICENSE.txt                           --
"--                                                --
"--                                Ver. 2015/04/15 --
"--                                                --
"----------------------------------------------------

"--------------- 制御 --------------- {{{1
" バックアップ作らない
set nobackup
set noundofile
" OSのクリップボードを使用する
set clipboard+=unnamed
" utf-8
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set termencoding=utf-8
if has('win32') || has('win64')
	scriptencoding cp932 "WindowsでKaoriya GVimを使うので内部エンコーディングはcp932
endif
" LF
set fileformat=unix
set fileformats=unix,dos,mac
" 複数ファイルの編集を可能にする
set hidden
" nohlsearch
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>


"--------------- 表示 --------------- {{{1
" 行番号を表示
set number
" ルーラーを表示
set ruler
" タイトルを表示
set title
" 括弧入力時に対応する括弧を表示
set showmatch
" 構文ハイライト
"  //NeoBundleの兼ね合いで最下部に移動
" タブの画面上での幅
set tabstop=4
" タブを挿入するときの幅
set shiftwidth=4
set softtabstop=0
" 自動インデント
set smartindent
set autoindent
" フォーマット揃えをコメント以外有効にする
set formatoptions-=c
" TAB,EOFなどを可視化する
set list
set listchars=tab:>-,extends:<,trail:-,eol:<
" カーソルの上下に表示する行数
set scrolloff=5
" 色々な色
"highlight Normal ctermbg=black ctermfg=grey
"highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
"highlight CursorLine term=none cterm=none ctermfg=none ctermbg=none
" 256色表示
set t_Co=256
"colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
set background=dark
" 折り返さない //2014.01.06 update.
"set nowrap
" カーソル行強調
set cursorline
" 常にステータス行を表示
set laststatus=2
" コマンドラインの高さ
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" ディレクトリツリー
let g:netrw_liststyle=3
" thanks! ＞ めんどくせーからvimrcそのまま晒す - Qiita [キータ] http://qiita.com/kotashiratsuka/items/dcd1f4231385dc9c78e7
" ファイルナンバー表示
set statusline=[%n]
" ホスト名表示
set statusline+=%{matchstr(hostname(),'\\w\\+')}@
" ファイル名表示
set statusline+=%<%F
" 変更のチェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" ヘルプページなら[HELP]と表示
set statusline+=%h
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" ファイルフォーマット表示
set statusline+=[%{&fileformat}]
" 文字コード表示
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
" ファイルタイプ表示
set statusline+=%y
" ここからツールバー右側
set statusline+=%=
" 文字バイト数/カラム番号
set statusline+=[%{col('.')-1}=ASCII=%B,HEX=%c]
" 現在文字列/全体列表示
set statusline+=[C=%c/%{col('$')-1}]
" 現在文字行/全体行表示
set statusline+=[L=%l/%L]
" 現在のファイルの文字数をカウント
set statusline+=[WC=%{exists('*WordCount')?WordCount():[]}]
" 現在行が全体行の何%目か表示
set statusline+=[%p%%]
" foldddddddd
set foldmethod=syntax
set foldlevel=2
set foldcolumn=2
" タブじゃなくスペース
set expandtab
set smarttab
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"--------------- 自動文字数カウント --------------- {{{1
augroup WordCount
    autocmd!
    autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
    if a:0 == 0
        return s:WordCountStr
    endif
    let cidx = 3
    silent! let cidx = s:WordCountDict[a:1]
    let s:WordCountStr = ''
    let s:saved_status = v:statusmsg
    exec "silent normal! g\<c-g>"
    if v:statusmsg !~ '^--'
        let str = ''
        silent! let str = split(v:statusmsg, ';')[cidx]
        let cur = str2nr(matchstr(str, '\d\+'))
        let end = str2nr(matchstr(str, '\d\+\s*$'))
        if a:1 == 'char'
            " ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
            let cr = &ff == 'dos' ? 2 : 1
            let cur -= cr * (line('.') - 1)
            let end -= cr * line('$')
        endif
        let s:WordCountStr = printf('%d/%d', cur, end)
    endif
    let v:statusmsg = s:saved_status
    return s:WordCountStr
endfunction

"--------------- JsonFormatter --------------- {{{1
" Vim (with python) で json を整形 - Qiita http://qiita.com/tomoemon/items/cc29b414a63e08cd4f89
command! JsonFormat :execute '%!python -m json.tool'
  \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :set ft=javascript
  \ | :1

"--------------- 検索 --------------- {{{1
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索時にファイルの最後まで行ったら最初に戻る
set wrapscan
" インクリメンタルサーチ
set incsearch

"--------------- keyMap --------------- {{{1
" Pukiwiki記法の改行
imap <C-Enter> &br;<Enter>
" 年-月-日&br;&br;
imap <C-D> <C-R>=strftime("%Y-%m-%d")<Enter><C-Enter><C-Enter>

"--------------- NeoBundle --------------- {{{1
if has('vim_starting')
	" VIM互換にしない
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif
" neobundle.vimの初期化
call neobundle#begin(expand('~/.vim/bundle'))
" NeoBundleを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

" plugins {{{2
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw64.mak',
    \ 'cygwin'  : 'make -f make_cygwin.mak',
    \ 'mac'     : 'make -f make_mac.mak',
    \ 'unix'    : 'make -f make_unix.mak',
  \ },
\ }
" A better JSON for Vim
NeoBundle 'elzr/vim-json'
" PukiWiki記法シンタックスハイライト
NeoBundle 'ytsunetsune/vim-pukiwiki-syntax'
" Add CSS3 syntax support
NeoBundle 'hail2u/vim-css3-syntax'
" HTML5 omnicomplete and syntax
NeoBundle 'othree/html5.vim'
" Vastly improved Javascript indentation and syntax support in Vim.
NeoBundle 'pangloss/vim-javascript'
" Syntax file for jQuery
NeoBundle 'nono/jquery.vim'
" A fancy start screen for Vim
NeoBundle 'mhinz/vim-startify'
" Source Explorer, TagList, NERD Tree to be an IDE
NeoBundle 'wesleyche/Trinity'
" exploring the source code based on tags
NeoBundle 'wesleyche/SrcExpl'
" ソースコード上のメソッド宣言、変数宣言の一覧を表示
NeoBundle 'taglist.vim'
" A tree explorer plugin for vim
NeoBundle 'scrooloose/nerdtree'
" PHP 5.6 syntax highlight for vim
NeoBundle 'StanAngeloff/php.vim'
" Open URI with your favorite browser
NeoBundle 'tyru/open-browser.vim'
" Next generation completion framework
NeoBundle 'Shougo/neocomplete.vim'
" The neocomplete source for PHP
NeoBundle 'violetyk/neocomplete-php.vim'
" simple memo plugin for Vim.
NeoBundle 'glidenote/memolist.vim'
" Realtime preview by Vim
NeoBundle 'kannokanno/previm'
" Typescript syntax files for Vim
NeoBundle 'leafgarland/typescript-vim'
" インデントに色を付けて見やすくする
NeoBundle 'nathanaelkane/vim-indent-guides'
" ログファイルを色づけしてくれる
NeoBundle 'AnsiEsc.vim'
" Automatically save changes to disk
"NeoBundle 'vim-auto-save'
" make benchmark result of your vimrc
NeoBundle 'mattn/benchvimrc-vim'
" Provides database access to many dbms
NeoBundle 'dbext.vim'
" A vim javascript indent script
NeoBundle 'jiangmiao/simple-javascript-indenter'
" Adjust Gvim font size via keypresses
NeoBundle 'drmikehenry/vim-fontsize'
" 行末の半角スペースを可視化
NeoBundle 'bronson/vim-trailing-whitespace'
" 括弧囲みの編集操作
NeoBundle 'tpope/vim-surround'
" Smartyのシンタクスハイライト
NeoBundle 'sifue/smarty.vim'
" markdownのシンタクスハイライトのためのプラグイン
NeoBundle 'godlygeek/tabular'
NeoBundle 'plasticboy/vim-markdown'

""colorscheme---
"NeoBundle 'tomasr/molokai'
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'github-theme'
NeoBundle 'cocopon/iceberg.vim'
" インストールのチェック
" 　起動速度向上のためプラグイン追加時は手動で。:w
"NeoBundleCheck


call neobundle#end()


let file_name = expand("%:p")
if has('vim_starting')
	if (file_name == "")
		"autocmd VimEnter * execute 'Startify'
	endif
	"autocmd VimEnter * execute 'Tlist'
	"autocmd VimEnter * execute 'NERDTree'
endif

"--------------- startify --------------- {{{3
" bookmark設定
let g:startify_bookmarks = [
	\ '~/.vimrc',
	\ '~/.gvimrc',
\ ]

"--------------- NERDTree --------------- {{{3
" 最後に残ったウィンドウがNERDTREEのみのときはvimを閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" 隠しファイルも表示
let NERDTreeShowHidden = 1
" copyコマンド
"  WindowsのgVimでNERD Treeプラグインのファイルコピーをちゃんと動かしたい - Qiita http://qiita.com/akase244/items/ad26efec8dcddded8e73
let g:NERDTreeCopyCmd    = 'cp -r '
" 表示設定
let g:NERDTreeWinSize    = 45
let g:NERDTreeWinPos     = "left"
let g:NERDTreeAutoCenter = 1
let g:NERDTreeDirArrows  = 0
" <C-e>でToggleする。
nmap <silent> <C-e>      :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
omap <silent> <C-e>      :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
cmap <silent> <C-e> <C-u>:NERDTreeToggle<CR>
" 表示しないファイルの設定
let g:NERDTreeIgnore = [
	\ '\.swp$',
\ ]

"--------------- Taglist --------------- {{{3
let g:Tlist_Auto_Update          = 1
let g:Tlist_Use_Right_Window     = 1
let g:Tlist_Sort_Type            = "order"
let g:Tlist_Compact_Format       = 1
let g:Tlist_Exit_OnlyWindow      = 1
let g:Tlist_File_Fold_Auto_Close = 1
let g:Tlist_Enable_Fold_Column   = 0
let g:Tlist_Show_One_File        = 0
map <Leader>t :Tlist<CR>
"  JavaScriptのソースでTagListプラグインを使う時にしとくべき設定 - SELECT * FROM life; http://yuku-tech.hatenablog.com/entry/20111012/1318416494
let g:tlist_javascript_settings  = 'javascript;c:class;m:method;F:function;p:property'

"--------------- PHP --------------- {{{3
" ssh上でマウススクロールも使える大規模PHP開発向けvim+tmux環境の構築 - しふーのブログ http://d.hatena.ne.jp/sifue/20130224/1361713497
" 文字列の中のSQLをハイライト
let php_sql_query = 1
" HTMLもハイライト
let php_htmlInStrings = 1
" <? を無効にする→ハイライト除外にする
let php_noShortTags = 1
" ] や ) の対応エラーをハイライト
let php_parent_error_close = 1
let php_parent_error_open = 1
" クラスと関数の折りたたみ
let php_folding = 1

let g:neocomplete_php_locale = 'ja'

"--------------- open-browser.vim --------------- {{{3
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"--------------- memolist.vim --------------- {{{3
map <Leader>ml  :MemoList<CR>
map <Leader>mn  :MemoNew<CR>
map <Leader>mg  :MemoGrep<CR>

"--------------- neocomplete.vim --------------- {{{3
let g:neocomplete#enable_at_startup = 1

"--------------- vim-indent-guides --------------- {{{3
let g:indent_guides_enable_on_vim_startup = 1

"--------------- vim-auto-save --------------- {{{3
"let g:auto_save = 1

"--------------- vim-javascript --------------- {{{3
let javascript_enable_domhtmlcss = 1

"--------------- Simple-Javascript-Indenter --------------- {{{3
" この設定入れるとshiftwidthを1にしてインデントしてくれる
let g:SimpleJsIndenter_BriefMode = 1
" この設定入れるとswitchのインデントがいくらかマシに
let g:SimpleJsIndenter_CaseIndentLevel = -1

" }}}1
"--------------- 構文ハイライト --------------- {{{1
syntax on
filetype plugin indent on
filetype indent on

"--------------- カラースキーム --------------- {{{1
"  ※必ず一番最後に！
"colorscheme molokai
colorscheme iceberg
set background=light
set background=dark
" }}}1


" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0
