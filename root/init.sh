#!/bin/bash

init() {
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get install -y build-essential
}

prezto(){
    clear
    sudo apt-get install -y git
    sudo apt-get install -y zsh
    # Get prezto
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto

    # Backup zsh config if it exists
    if [ -f ~/.zshrc ];
       then
           mv ~/.zshrc ~/.zshrc.backup
    fi

    # Create links to zsh config files
    ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
    ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
    ln -s ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc
    ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
    ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
    ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc

    if grep -Fxq "exec zsh" ~/.bashrc
    then
        echo "ZSH already added to ~/.bashrc"
    else
        printf '\nif [ -t 1 ]; then\nexec zsh\nfi' >> ~/.bashrc
    fi
}

node.install(){
    init
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

    # Restart shell
    exec zsh -l

    # Install Node
    nvm install stable
}
