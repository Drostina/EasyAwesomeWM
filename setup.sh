#!/bin/bash
welcome()
{
    draw_logo

    echo "Welcome to EasyAwesomeWM"
    echo
    echo "Note: this program is for a fresh install of awesome and may override your awesome config if have already configured it. 
    If you just want the themes, refer to the manual installation section on the GitHub read me"
    echo 

    read -p "Are you sure you want to continue? (Y/n)?" choice
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
    read -p "(Mandatory) Awesome: the main aspect of this pack (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install awesome ;;
    n|N ) exit ;;
    * ) exit ;;
    esac

    gap

    read -p "Do you want to go through the optional but recommended dependencies? (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) optional ;;
    n|N ) config ;;
    esac
}

optional()
{
    clear

    draw_logo

    read -p "alacritty: fast and gpu accelerated terminal emulator (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install alacritty ;;
    esac


    read -p "picom: compositor that helps with reducing screen tearing and allows you to add window effects (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install picom ;;
    esac

    gap 

    read -p "lxpolkit: Policy kit for priviledges and permission (needed if you are trying to install apps from the software stores) (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install lxpolkit ;;
    esac

    gap 
    
    read -p "pavucontrol: for audio control and output/input switch (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install pavucontrol ;;
    esac

    gap 
    
    read -p "rofi: application launcher (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install rofi ;;
    esac

    gap

    read -p "playerctl: for media buttons to work (i.e if your keyboard has previous, pause, next) (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install playerctl ;;
    esac

    gap

    read -p "xbacklight: for brightness control (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install xbacklight ;;
    esac

    gap

    read -p "nitrogen: to set wallpapers (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install nitrogen ;;
    esac

    gap

    read -p "lxappearance: to set GTK themes and icons (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install lxappearance ;;
    esac

    gap

    read -p "papirus-icon-theme: set of beautiful icons that can be used with GTK and rofi (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install papirus-icon-theme ;;
    esac

    gap

    read -p "flameshot: screenshotting tool(Y/n)" choice
    case "$choice" in 
    y|Y|"" ) sudo apt install flameshot ;;
    esac

    config

}

config()
{
    clear

    draw_logo

    echo "We are almost there! Now to setup the configs and dotfiles(themes)"
    echo "Warning, if you already have configs the following will override it"
    read -p "Do you want to setup the themes for awesome? (Y/n) " choice
    case "$choice" in 
    y|Y|"" ) 
    cp -a awesome/ $HOME/.config
    echo "themes copied to: $HOME/.config/awesome"
    ;;
    esac

    gap

    read -p "Do you want to setup the dracula alacritty config (if you installed Alacritty)? (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) 
    cp -a alacritty/ $HOME/.config
    echo "config copied to: $HOME/.config/alacritty"
    ;;
    esac

    read -p "Do you want to setup the recommended rofi config (if you installed Rofi)? (Y/n)" choice
    case "$choice" in 
    y|Y|"" ) 
    cp -a rofi/ $HOME/.config
    echo "config copied to: $HOME/.config/rofi"
    ;;
    esac
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

clear
welcome