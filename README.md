dotfiles
========
個人的な'.'で始まるファイルたち。

Copyright (c) 2014 xxxkurosukexxx  
Released under the MIT license  
See [LICENSE.txt](https://github.com/xxxkurosukexxx/dotfiles/blob/master/LICENSE.txt)  

Usage
----------
```bash
$ git clone https://github.com/xxxkurosukexxx/dotfiles ~/dotfiles
$ ln -s ~/dotfiles/.vimrc ~/.vimrc
$ ln -s ~/dotfiles/.vimshrc ~/.vimshrc
$ mkdir -p ~/.vim/bundle
$ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
$ vim +NeoBundleInstall +qall
```

99_setupVim.sh
---------------
vimの自動ビルド＆インストール＆セットアップシェル。
詳細はソース参照。
