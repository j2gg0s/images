#! /bin/bash
export http_proxy=http://j2gg0s-osx.local:8118
export https_proxy=http://j2gg0s-osx.local:8118

apt install -y \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  curl \
  git \
  zsh \
  universal-ctags \
  make \
  vim

systemctl is-active docker
if [[ $? -ne 0 ]]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update
  apt install -y docker-ce
fi

if [[ ! -e $HOME/.vimrc ]]; then
  rm -rf $HOME/.vim
  git clone git@github.com:j2gg0s/vim.git $HOME/.vim
  ln -s $HOME/.vim/vimrc $HOME/.vimrc
  ln -s $HOME/.vim/gitconfig $HOME/.gitconfig
fi

if [[ $ZSH == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  rm $HOME/.zshrc
  ln -s $HOME/.vim/zsrhc $HOME/.zshrc
fi

if [[ ! -e $HOME/images ]]; then
  git clone git@github.com:j2gg0s/images.git $HOME/images
fi
