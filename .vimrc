"----------------------------------------
"--
"-- .vimrc for @xxxkurosukexxx
"-- http://twitter.com/xxxkurosukexxx
"--
"-- Ver. 2014/04/16
"--
"----------------------------------------

"--------------- 制御 ---------------
" VIM互換にしない
"  //NeoBundleの兼ね合いで下の方に移動
" バックアップ作らない
set nobackup
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

"--------------- 表示 ---------------
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

"--------------- 自動文字数カウント ---------------
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

"--------------- JsonFormatter ---------------
" Vim (with python) で json を整形 - Qiita http://qiita.com/tomoemon/items/cc29b414a63e08cd4f89
command! JsonFormat :execute '%!python -m json.tool'
  \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :set ft=javascript
  \ | :1

"--------------- 検索 ---------------
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索時にファイルの最後まで行ったら最初に戻る
set wrapscan
" インクリメンタルサーチ
set incsearch

"--------------- keyMap ---------------
" Pukiwiki記法の改行
imap <C-Enter> &br;<Enter>
" 年-月-日&br;&br;
imap <C-D> <C-R>=strftime("%Y-%m-%d")<Enter><C-Enter><C-Enter>

"--------------- NeoBundle ---------------
if has('vim_starting')
	" VIM互換にしない
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif
" neobundle.vimの初期化 
call neobundle#rc(expand('~/.vim/bundle'))
" NeoBundleを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'
" plugins
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin'  : 'make -f make_cygwin.mak',
    \ 'mac'     : 'make -f make_mac.mak',
    \ 'unix'    : 'make -f make_unix.mak',
  \ },
\ }
NeoBundle 'elzr/vim-json'
NeoBundle 'ytsunetsune/vim-pukiwiki-syntax'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'othree/html5.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'nono/jquery.vim'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'wesleyche/Trinity'
NeoBundle 'wesleyche/SrcExpl'
NeoBundle 'taglist.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'shawncplus/php.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'violetyk/neocomplete-php.vim'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'kannokanno/previm'
""colorscheme---
NeoBundle 'tomasr/molokai'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'github-theme'
NeoBundle 'cocopon/iceberg.vim'
" インストールのチェック
NeoBundleCheck

" 構文ハイライト
syntax on
filetype plugin indent on
filetype indent on

let file_name = expand("%:p")
if has('vim_starting')
	if (file_name == "")
		autocmd VimEnter * execute 'Startify'
	endif
	autocmd VimEnter * execute 'Tlist'
	autocmd VimEnter * execute 'NERDTree'
endif

"--------------- startify ---------------
" bookmark設定
let g:startify_bookmarks = [ 
	\ '~/.vimrc',
	\ '~/.gvimrc',
\ ]

"--------------- NERDTree ---------------
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

"--------------- Taglist ---------------
let g:Tlist_Auto_Update          = 1
let g:Tlist_Use_Right_Window     = 1
let g:Tlist_Sort_Type            = "order"
let g:Tlist_Compact_Format       = 1
let g:Tlist_Exit_OnlyWindow      = 1
let g:Tlist_File_Fold_Auto_Close = 1
let g:Tlist_Enable_Fold_Column   = 0
let g:Tlist_Show_One_File        = 0

"--------------- PHP ---------------
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

"--------------- open-browser.vim ---------------
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"--------------- memolist.vim ---------------
map <Leader>ml  :MemoList<CR>
map <Leader>mn  :MemoNew<CR>
map <Leader>mg  :MemoGrep<CR>


" カラースキーム
"  ※必ず一番最後に！
"colorscheme molokai
colorscheme iceberg
set background=light
set background=dark
