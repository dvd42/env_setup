#! /bin/bash
sudo apt-get -y install wget tar libevent-dev libncurses-dev

VERSION=3.1
wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
tar xf tmux-${VERSION}.tar.gz
rm -f tmux-${VERSION}.tar.gz

cd tmux-${VERSION}
./configure
make
sudo make install
cd -
sudo rm -rf /usr/local/src/tmux-\*
sudo mv tmux-${VERSION} /usr/local/src

sudo apt-get -y install xclip
sudo apt-get -y install acpi

cd
ln -s -f .config/env_setup/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/.config/env_setup/tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tmux-continuum.git ~/.config/env_setup/tmux/plugins/tmux-continuum
git clone https://github.com/pwittchen/tmux-plugin-ip.git ~/.config/env_setup/tmux/plugins/tmux-plugin-ip

echo TERM=screen-256color >> ~/.bashrc
source ~/.bashrc
