#!/bin/bash
welcome()
{
    draw_logo

    echo "Welcome to EasyAwesomeWM"
    echo
    echo "Note: this program is for a fresh install of awesome and may override your awesome config if have already configured it. 
    If you just want the themes, refer to the manual installation section on the GitHub read me"
    echo 

    read -r -p "Are you sure you want to continue? (Y/n)?" choice
    case "$choice" in 
    y|Y|"" ) dependencies ;;
    n|N ) exit ;;
    * ) exit ;;
    esac
}

dependencies()
{
    clear

    draw_logo

    echo "First let's go through the dependencies"
    read -r -p "(Mandatory) Awesome: the main aspect of this pack (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) 
    sudo apt update
    sudo apt install awesome 
    ;;
    n|N ) exit ;;
    * ) exit ;;
    esac

    gap

    read -r -p "Do you want to go through the optional but recommended dependencies? (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) optional ;;
    n|N ) config ;;
    esac
}

optional()
{
    clear

    draw_logo

    install_optional "alacritty: fast and gpu accelerated terminal emulator" "alacritty"

    gap

    install_optional "picom: compositor that helps with reducing screen tearing and allows you to add window effects" "picom"

    gap 

    install_optional "lxpolkit: Policy kit for priviledges and permission (needed if you are trying to install apps from the software stores)" "lxpolkit"

    gap 
    
    install_optional "pavucontrol: for audio control and output/input switch" "pavucontrol"

    gap 
    
    install_optional "rofi: application launcher" "rofi"

    gap

    install_optional "playerctl: for media buttons to work (i.e if your keyboard has previous, pause, next)" "playerctl"

    gap

    install_optional "xbacklight: for brightness control" "xbacklight"

    gap

    install_optional "nitrogen: to set wallpapers" "nitrogen"

    gap

    install_optional "lxappearance: to set GTK themes and icons" "lxappearance"

    gap

    install_optional "papirus-icon-theme: set of beautiful icons that can be used with GTK and rofi" "papirus-icon-theme"

    gap

    install_optional "flameshot: screenshotting tool" "flameshot"

    config

}

config()
{
    clear

    draw_logo

    echo "We are almost there! Now to setup the configs and dotfiles(themes)"
    echo "Warning, if you already have configs the following will override it"
    read -r -p "Do you want to setup the themes for awesome? (Y/n) " choice
    case "$choice" in 
    y|Y|"" ) 
    cp -a awesome/ "$HOME"/.config
    echo "themes copied to: $HOME/.config/awesome"
    ;;
    esac

    gap

    read -r -p "Do you want to setup the dracula alacritty config (if you installed Alacritty)? (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) 
    cp -a alacritty/ "$HOME"/.config
    echo "config copied to: $HOME/.config/alacritty"
    ;;
    esac

    gap
    
    read -r -p "Do you want to setup the recommended rofi config (if you installed Rofi)? (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) 
    cp -a rofi/ "$HOME"/.config
    echo "config copied to: $HOME/.config/rofi"
    ;;
    esac

    clear
    echo "Finished! Restart and switch to awesome in the login screen."
}

draw_logo()
{
    echo "
    █▀▀ ▄▀█ █▀ █▄█ ▄▀█ █░█░█ █▀▀ █▀ █▀█ █▀▄▀█ █▀▀ █░█░█ █▀▄▀█
    ██▄ █▀█ ▄█ ░█░ █▀█ ▀▄▀▄▀ ██▄ ▄█ █▄█ █░▀░█ ██▄ ▀▄▀▄▀ █░▀░█
    "
}

gap()
{
    echo
    echo
}

install_optional()
{
    read -r -p "$1""(Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install "$2" ;;
    esac
}

clear
welcome