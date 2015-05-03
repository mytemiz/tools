#!/bin/bash
# @author pcmos
# @date 03.05.2015
# Ubuntu , vim NERDTree plugini yükleme scripti
#
# adresteki linkten esinlenerek yapılmıştır. 
# https://livesoncoffee.wordpress.com/2013/04/12/install-nerd-tree-vim-plugin/
#

echo "Gerekli paketler toplanıyor..."

packages=('curl' 'git');

for package in ${packages[@]}
do
    tmppath="5oOvW"  # $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
    var=$(dpkg -s ${package} > /tmp/$tmppath 2>&1 ; cat /tmp/$tmppath | grep -c "ok")


    if [[ $var -ge 1 ]]
    then
        echo -e "Paket bulundu -- [\e[1;32m ${package} \e[0;32m]"
    else
        echo -e "\e[0;31mBu paket yüklü değil! -- [\e[1;31m ${package} ]\e[0;32m"
        read -r -p "Paket yüklensin mi? [Y/n] " response
        if [[ $response =~ ^([yY])*$ ]]
        then
            sudo apt-get install $package
        else
            echo -e "\e[0;33mİşlem iptal ediliyor..."
            exit -1
        fi
fi
done

echo -e "[\e[1;32m+\e[0;32m]Paketler kurulum için hazırlandı."

mkdir -p ~/.vim/autoload ~/.vim/bundle
echo "mkdir -p ~/.vim/autoload ~/.vim/bundle"

echo -e "\e[33;5m Pathogen indiriliyor...\e[0;32m"
curl -LSso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

echo ".vimrc düzenleniyor..."
vimrc_conf="\" Pathogen
execute pathogen#infect()
call pathogen#helptags() \" generate helptags for everything in 'runtimepath'
syntax on
filetype plugin indent on"

echo "$vimrc_conf" >> ~/.vimrc

# INSTALL NERDTREE

cd ~/.vim/bundle
git clone https://github.com/scrooloose/nerdtree.git

echo "NERDTree başarıyla yüklendi. :)"
