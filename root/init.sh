# #!/bin/bash
# #
# # Helper script to facilitate easy re-installing of WSL setup.

# Acquire Sudo permissions at the beginning of the script
sudo "true"

# Set Debian Frontend as noninteractive as we do not want to interact
# during installation
sudo dpkg-reconfigure debconf --frontend=noninteractive
# export DEBIAN_FRONTEND=noninteractive

#######################################
# Helper function to install packages.
# Arguments:
#   comma separated packages to install.
# Returns:
#   0 if install successful.
# Outputs:
#   Error messages if any.
#######################################
function install_helper() {
  sudo apt-get --yes --allow-downgrades install "$@" > /dev/null
}

#######################################
# Update Ubuntu system components.
# Arguments:
#   None
#######################################
function update() {
  sudo apt-get --yes --allow-downgrades update > /dev/null
  sudo apt-get --yes --allow-downgrades upgrade > /dev/null
}

#######################################
# Install Zsh shell.
# Arguments:
#   None
#######################################
function install_zsh(){
  (install_helper zsh)
  
  sudo sed s/required/sufficient/g -i /etc/pam.d/chsh
  
  # Change Default shell to zsh
  chsh -s $(which zsh)
}

#######################################
# Install antibody for Zsh shell and copy config files.
# Arguments:
#   None
#######################################
function install_antibody(){
  (install_zsh)
  
  echo bash | sudo -S curl -sfL git.io/antibody | sudo -S sh -s - -b /usr/local/bin
  
  cp .zsh_plugins.txt ~/.zsh_plugins.txt
  cp .zshrc ~/.zshrc
}

#######################################
# Install starship and add config for Zsh.
# Arguments:
#   None
#######################################
function install_starship() {
  (install_antibody)
  
  curl -fsSL https://starship.rs/install.sh | sudo bash -s -- -y
  
  mkdir -p ~/.config && cp starship.toml ~/.config/starship.toml
}

#######################################
# Install build-essesntial.
# Arguments:
#   None
#######################################
install_build(){
  # Update OS before proceeding
  (update)
  
  (install_helper build-essential)
}

#######################################
# Install python.
# Arguments:
#   None
#######################################
install_python(){
  # Install Build Essentials
  (install_build)
  
  # Install pre requisites
  (install_helper software-properties-common)
  
  # Install python
  (install_helper python3.8 python3-pip)
  
  # Create symlink for python with python 3.8
  sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
}
