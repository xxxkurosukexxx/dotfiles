#!/bin/bash

##################################################
##
## Install Vim with Lua.
##   This is for myself...
##
##################################################

echo "-------------------------"
echo "- Install Vim with Lua. -"
echo "-------------------------"
echo;


### --- reinstall vim with lua ---

if type vim >/dev/null 2>&1; then
    sudo yum -y erase vim
fi

sudo yum -y install mercurial lua lua-devel ncurses-devel perl perl-devel perl-ExtUtils-Embed ruby ruby-devel python python-devel

cd /usr/local/src/

sudo hg clone https://code.google.com/p/vim/ && cd vim

sudo ./configure --with-features=huge \
                 --disable-darwin \
                 --disable-selinux \
                 --enable-luainterp \
                 --enable-perlinterp \
                 --enable-pythoninterp \
                 --enable-python3interp \
                 --enable-tclinterp \
                 --enable-rubyinterp \
                 --enable-cscope \
                 --enable-multibyte \
                 --enable-xim \
                 --enable-fontset \
                 --prefix=/usr/local

sudo make && sudo make install


### --- install NeoBundle ---

cd ~
mkdir -p ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim


### --- linking ---

if [ ! -e ~/.vimrc ]; then
    ln -s ~/dotfiles/.vimrc ~/.vimrc
fi


##### --- init NeoBundle ---

vim +NeoBundleInstall +qall


##### --- for root... ---

sudo mkdir -p /root/.vim/
sudo ln -s ~/.vim/bundle /root/.vim/bundle
sudo ln -s ~/.vimrc /root/.vimrc


### --- finish! ---

echo;
vim --version
echo;

echo;
echo "...done!";
echo;

exit;
