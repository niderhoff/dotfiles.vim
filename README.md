# vim dotfiles

## Installation
    $ git clone http://github.com/niderhoff/dotfiles.vim ~/.vim

## Create symlinks
    $ ln -s ~/.vim/vimrc ~/.vimrc
    $ ln -s ~/.vim/gvimrc ~/.gvimrc

## Fetch submodules
    $ cd ~/.vim
    $ git submodule init
    $ git submodule update
    $ git submodule --recursive git pull
