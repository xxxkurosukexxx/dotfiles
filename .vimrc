"----------------------------------------------------
"--                                                --
"--           .vimrc for @xxxkurosukexxx           --
"--       https://twitter.com/xxxkurosukexxx       --
"--                                                --
"--      Copyright (c) 2014 xxxkurosukexxx         --
"--      Released under the MIT license            --
"--      See LICENSE.txt                           --
"--                                                --
"--                                Ver. 2016/02/24 --
"--                                                --
"----------------------------------------------------

" utf-8
set encoding=utf-8
scriptencoding utf-8

"--------------- 制御 --------------- {{{1
" バックアップ作らない
set nobackup
set noundofile
" OSのクリップボードを使用する
set clipboard+=unnamed
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set termencoding=utf-8
if has('win32') || has('win64')
    scriptencoding cp932 "WindowsでKaoriya GVimを使うので内部エンコーディングはcp932
    set shellslash
endif
" LF
set fileformat=unix
set fileformats=unix,dos,mac
" 複数ファイルの編集を可能にする
set hidden
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" コマンドライン補完するときに強化されたものを使う
set wildmenu
" splitした時下に
set splitbelow
" splitした時右に
set splitright
" 自動インデント
set smartindent
set autoindent
"set paste
" フォーマット揃えをコメント以外有効にする
set formatoptions-=c
"}}}

"--------------- 表示 --------------- {{{
" 行番号を表示
set number
" ルーラーを表示
set ruler
" タイトルを表示
set title
" 括弧入力時に対応する括弧を表示
set showmatch
" タブの画面上での幅
set tabstop=4
" タブを挿入するときの幅
set shiftwidth=4
set softtabstop=0
" TAB,EOFなどを可視化する
set list
set listchars=tab:>-,extends:<,trail:-,eol:<
" カーソルの上下に表示する行数
set scrolloff=5
" 256色表示
set t_Co=256
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
" ハイライト
set hlsearch
"}}}

"--------------- 自動文字数カウント --------------- {{{
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
"}}}

"--------------- JsonFormatter --------------- {{{
" Vim (with python) で json を整形 - Qiita http://qiita.com/tomoemon/items/cc29b414a63e08cd4f89
command! JsonFormat :execute '%!python -m json.tool'
            \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)), sys.stdin.read()))"'
            \ | :%s/ \+$//ge
            \ | :set ft=javascript
            \ | :1
"}}}

"--------------- 検索 --------------- {{{
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索時にファイルの最後まで行ったら最初に戻る
set wrapscan
" インクリメンタルサーチ
set incsearch
"}}}

"--------------- keyMap --------------- {{{
" nohlsearch
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
" 末尾の半角スペース2つを<br>に
nnoremap <Leader>sb :%s/  $/<br>/g<CR><Esc>
" ft=markdownのショートカット
nnoremap <Leader>fm :set<Space>ft=markdown<CR><Esc>
nnoremap <Leader>fj :set<Space>ft=javascript<CR><Esc>
nnoremap <Leader>fs :set<Space>ft=sql<CR><Esc>
nnoremap <Leader>fp :set<Space>ft=php<CR><Esc>
nnoremap <Leader>fh :set<Space>ft=html<CR><Esc>
"}}}

"--------------- NeoBundle --------------- {{{
if has('vim_starting')
    " VIM互換にしない 2015.05.13 vimrcアンチパターン - rbtnn雑記 http://rbtnn.hateblo.jp/entry/2014/11/30/174749
    if &compatible
        set nocompatible
    endif
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
" neobundle.vimの初期化
call neobundle#begin(expand('~/.vim/bundle'))
" NeoBundleを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

" plugins {{{
NeoBundle 'Shougo/vimproc.vim', {
            \ 'build' : {
            \     'windows' : 'tools\\update-dll-mingw',
            \     'cygwin'  : 'make -f make_cygwin.mak',
            \     'mac'     : 'make -f make_mac.mak',
            \     'linux'   : 'make',
            \     'unix'    : 'gmake',
            \    },
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
"NeoBundle 'mhinz/vim-startify'
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
NeoBundle 'Konfekt/FastFold'
" The neocomplete source for PHP
NeoBundle 'violetyk/neocomplete-php.vim'
" simple memo plugin for Vim.
NeoBundle 'glidenote/memolist.vim'
" Realtime preview by Vim
NeoBundle 'kannokanno/previm' ", '46-support-latest-open-browser'
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
" Blade用
NeoBundle 'xsbeats/vim-blade'
" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'kmnk/vim-unite-svn'
NeoBundle 'taka84u9/unite-git'
NeoBundle 'ujihisa/unite-colorscheme'
" vimshell
NeoBundle 'Shougo/vimshell.vim'
" SQLUtilities
NeoBundle 'SQLUtilities', {
            \    'depends': 'Align'
            \}
" 緊急地震速報 on Vim
"NeoBundle 'haya14busa/eew.vim' "Windowsで上手く動かせなかった...
" NicoNico like comments on Vim
NeoBundle 'haya14busa/niconicomment.vim'

""colorscheme---
NeoBundle 'tomasr/molokai'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'github-theme'
NeoBundle 'cocopon/iceberg.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'rhysd/vim-color-splatoon'

call neobundle#end()
"}}}

"--------------- UniteStartup --------------- {{{
" vim-startify を unite.vim で代替してみる - C++でゲームプログラミング
"  http://d.hatena.ne.jp/osyo-manga/20131217/1387292034
let g:unite_source_alias_aliases = {
            \   "startup_file_mru" : {
            \       "source" : "file_mru",
            \   },
            \   "startup_directory_mru" : {
            \       "source" : "directory_mru",
            \   },
            \}

call unite#custom_max_candidates("startup_file_mru", 10)
call unite#custom_max_candidates("startup_directory_mru", 5)

if !exists("g:unite_source_menu_menus")
    let g:unite_source_menu_menus = {}
endif

let g:unite_source_menu_menus.startup = {
            \   "description" : "startup menu",
            \   "command_candidates" : [
            \       [ "edit",  "edit" ],
            \       [ ".vimrc",  "edit " . $MYVIMRC ],
            \       [ ".gvimrc", "edit " . $MYGVIMRC ],
            \       [ "unite-file_mru", "Unite file_mru" ],
            \       [ "unite-directory_mru", "Unite directory_mru" ],
            \   ]
            \}

command! UniteStartup
            \   Unite
            \   output:echo:"===:file:mru:===":! startup_file_mru
            \   output:echo:":":!
            \   output:echo:"===:directory:mru:===":! startup_directory_mru
            \   output:echo:":":!
            \   output:echo:"===:menu:===":! menu:startup
            \   -hide-source-names
            \   -no-split
            \   -quick-match

augroup startup
    autocmd!
    autocmd VimEnter * nested if @% == ''  && s:GetBufByte() == 0 | execute 'UniteStartup' | endif
augroup END

" vimを引数なしで起動した場合に◯◯を行う - Make 鮫 noise
"  http://saihoooooooo.hatenablog.com/entry/2013/05/24/130744
function! s:GetBufByte()
    let byte = line2byte(line('$') + 1)
    if byte == -1
        return 0
    else
        return byte - 1
    endif
endfunction
"}}}

"--------------- NERDTree --------------- {{{
" 最後に残ったウィンドウがNERDTREEのみのときはvimを閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" 隠しファイルも表示
let g:NERDTreeShowHidden = 1
" copyコマンド
"  WindowsのgVimでNERD Treeプラグインのファイルコピーをちゃんと動かしたい - Qiita http://qiita.com/akase244/items/ad26efec8dcddded8e73
let g:NERDTreeCopyCmd    = 'cp -r '
" 表示設定
let g:NERDTreeWinSize    = 45
let g:NERDTreeWinPos     = "left"
let g:NERDTreeAutoCenter = 1
let g:NERDTreeDirArrows  = 0
" <C-e>でToggleする。
nnoremap <silent> <C-e>      :NERDTreeToggle<CR>
vnoremap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
onoremap <silent> <C-e>      :NERDTreeToggle<CR>
inoremap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
cnoremap <silent> <C-e> <C-u>:NERDTreeToggle<CR>
" 表示しないファイルの設定
let g:NERDTreeIgnore = [
            \ '\.swp$',
            \ ]
"}}}

"--------------- Taglist --------------- {{{
let g:Tlist_Auto_Update          = 1
let g:Tlist_Use_Right_Window     = 1
let g:Tlist_Sort_Type            = "order"
let g:Tlist_Compact_Format       = 1
let g:Tlist_Exit_OnlyWindow      = 1
let g:Tlist_File_Fold_Auto_Close = 1
let g:Tlist_Enable_Fold_Column   = 0
let g:Tlist_Show_One_File        = 0
nnoremap <Leader>t :Tlist<CR>
"  JavaScriptのソースでTagListプラグインを使う時にしとくべき設定 - SELECT * FROM life; http://yuku-tech.hatenablog.com/entry/20111012/1318416494
let g:tlist_javascript_settings  = 'javascript;c:class;m:method;F:function;p:property'
"}}}

"--------------- PHP --------------- {{{
" ssh上でマウススクロールも使える大規模PHP開発向けvim+tmux環境の構築 - しふーのブログ http://d.hatena.ne.jp/sifue/20130224/1361713497
" 文字列の中のSQLをハイライト
let g:php_sql_query = 1
" HTMLもハイライト
let g:php_htmlInStrings = 1
" <? を無効にする→ハイライト除外にする
let g:php_noShortTags = 1
" ] や ) の対応エラーをハイライト
let g:php_parent_error_close = 1
let g:php_parent_error_open = 1
" クラスと関数の折りたたみ
let g:php_folding = 1

let g:neocomplete_php_locale = 'ja'

function! PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
    autocmd!
    autocmd FileType php call PhpSyntaxOverride()
augroup END
"}}}

"--------------- open-browser.vim --------------- {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
noremap  <Leader>gx <Plug>(openbrowser-smart-search)
vnoremap <Leader>gx <Plug>(openbrowser-smart-search)
"}}}

"--------------- memolist.vim --------------- {{{
noremap <Leader>ml  :MemoList<CR>
noremap <Leader>mn  :MemoNew<CR>
noremap <Leader>mg  :MemoGrep<CR>
"}}}

"--------------- neocomplete.vim --------------- {{{
let g:neocomplete#enable_at_startup = 1
"}}}

"--------------- vim-indent-guides --------------- {{{
let g:indent_guides_enable_on_vim_startup = 1
"}}}

"--------------- vim-auto-save --------------- {{{
"let g:auto_save = 1
"}}}

"--------------- vim-javascript --------------- {{{
let g:javascript_enable_domhtmlcss = 1
"}}}

"--------------- Simple-Javascript-Indenter --------------- {{{
" この設定入れるとshiftwidthを1にしてインデントしてくれる
let g:SimpleJsIndenter_BriefMode = 1
" この設定入れるとswitchのインデントがいくらかマシに
let g:SimpleJsIndenter_CaseIndentLevel = -1
"}}}

"--------------- unite.vim --------------- {{{
nnoremap [unite]   <Nop>
nmap     <Space>u [unite]
nnoremap [unite]u  :<C-u>Unite -no-split<Space>
nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]b :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
nnoremap <silent> [unite]y :<C-u>Unite<Space>history/yank<CR>
nnoremap <silent> [unite]h :<C-u>Unite<Space>history/unite<CR>
nnoremap <silent> [unite]r :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> ,vr :UniteResume<CR>
let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 500
let g:unite_source_history_yank_enable = 1
"}}}

"--------------- SQLUtilities --------------- {{{
let g:sqlutil_align_where = 1
let g:sqlutil_align_comma = 1
nnoremap <Leader>sql :SQLUFormatter<CR>
"}}}

"}}}

"--------------- 構文ハイライト --------------- {{{
syntax on
filetype plugin indent on
"}}}

"--------------- カラースキーム --------------- {{{
"  ※必ず一番最後に！
"colorscheme molokai
"colorscheme iceberg
"set background=light
set background=dark
colorscheme hybrid
"colorscheme hybrid-light "←こっちは白背景なのでプロジェクターで映すときとかにいいかも？
"}}}

" vim: foldmethod=marker foldcolumn=3 foldlevel=0
