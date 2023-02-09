#!/bin/bash

# 
# Bootstrap script for setting up a new Ubuntu machine
# Inspired by: https://gist.github.com/plagioriginal/7bdc75f3067b2555d066b0e610639d0e
# 

log_header() {
    echo ""
    echo "---  $1  ---"
    echo "---------------------------------------------"   
}

log_line() {
    echo "### $1 ###"
}

#
# Installs apt packages
#
install_apt_packages() {
    PACKAGES=(
        ansible
        apt-file
        docker.io
        filezilla
        genisoimage
        guestfs-tools
        make
        mkisofs
        nfs-common
        pandoc
        sshpass
        virt-manager
    )

    sudo apt-get -y install ${PACKAGES[@]}
    sudo apt-get -y install ubuntu-restricted-extras ubuntu-restricted-addons
    sudo apt-file update
}

#
# Installs snap packages
#
install_snap_packages() {
    PACKAGES=(
        caffeine
        chromium
        firefox
        libreoffice
        spotify
        vlc
    )

    for package in "${PACKAGES[@]}"
    do
        sudo snap install $package
    done

    PACKAGES=(
        code
        gitkraken
        powershell
        slack
    )

    for package in "${PACKAGES[@]}"
    do
        sudo snap install $package --classic
    done
}

#
# Installs github cli
#
install_github_cli() {

    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    
}

#
# Installs hashicorp binaries
#
install_hasicorp() {

    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform packer
    
}



#
# Installs debs that aren't in repos
#
install_debs() {

    wget -O /tmp/Termius.deb https://www.termius.com/download/linux/Termius.deb
    sudo dpkg -i /tmp/Termius.deb

}

log_line "Starting bootstrapping"

log_header "Update apt and system"
sudo apt-get update && sudo apt-get -y dist-upgrade

log_header "Installing apt packages..."
install_apt_packages

log_header "Installing single debs..."
install_debs

log_header "Installing github cli..."
install_github_cli

log_header "Installing terraform and packer..."
install_hasicorp

log_header "Installing snap packages..."
install_snap_packages
