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
        filezilla
        guestfs-tools
        virt-manager
    )

    sudo apt-get -y install ${PACKAGES[@]}
    sudo apt-get -y install ubuntu-restricted-extras ubuntu-restricted-addons
}

#
# Installs snap packages
#
install_snap_packages() {
    PACKAGES=(
        chromium
        firefox
        libreoffice
        spotify
        termius-app
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

log_line "Starting bootstrapping"

log_header "Update apt and system"
sudo apt-get update && sudo apt-get -y dist-upgrade

log_header "Installing apt packages..."
install_apt_packages

log_header "Installing snap packages..."
install_snap_packages
