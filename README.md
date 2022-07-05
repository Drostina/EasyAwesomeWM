# What is EasyAwesomeWm? 

It is a simple script that will install AwesomeWM and plenty of customised themes alongside your current distro's desktop. I made this for myself to go along with my PopOS setup as I am not a fan of the default gnome desktop.  

📝 ✔️ This is for those who want a functioning Awesome based desktop out of the box to modify parts of and experience the beauty of a dynamic tiling window manager without any hassle of setting it up from scratch\
📝 ❌ If you are a tinkerer and want to setup your own desktop, this project is maybe not for you

NOTE: The setup script is for a fresh install of awesome and the supplied themes and may override your configs, if you wish to keep your config please manually install the dotfiles yourself

This pack is based on a modified version of https://github.com/lcpz/awesome-copycats
So please show them some love also :)

Super easy to use settings file that syncs with each theme. No more setting up variables for each theme!

![Settings](https://i.imgur.com/fi4JQkU.png)

# Themes

Neon
![Neon](https://i.imgur.com/6PHbEWn.jpg)

Genesis
![Genesis](https://i.imgur.com/FUH610d.png)

Matcha
![Matcha](https://i.imgur.com/cVMX0Sj.png)

RGB
![RGB](https://i.imgur.com/Q9gNjFt.png)

Calm Red
![Calm Red](https://i.imgur.com/YxiBQrq.png)

# How to install (Automatic)

--Experimental--
(Ubuntu Based Distros ONLY -- uses apt commmands) Download zip of this repository, extract it, then right click in the folder and "run terminal here" or alternatively cd into it, then run "./setup.sh"

# How to install (Manual)

## Step 1

Download a zip of this repository.

## Step 2

First check the dependencies and choose which ones you would like to install.

first update with:
ubuntu based: "sudo apt update"
arch based: "sudo pacman -Syu" 

install packages with -> 
ubuntu based: "sudo apt install packagename"
arch based: "sudo pacman -S packagename" 

Mandatory packages:

awesome: dynamic tiling window manager

optional packages:

alacritty: fast and gpu accelerated terminal emulator
picom: compositor that helps with reducing screen tearing and allows you to add window effects
lxpolkit: Policy kit for priviledges and permission (needed if you are trying to install apps from the software stores)
pavucontrol: for audio control and output/input switch
rofi: application launcher
playerctl: for media buttons to work (i.e if your keyboard has previous, pause, next)
xbacklight: for brightness control
nitrogen: to set wallpapers
lxappearance: to set GTK themes and icons
papirus-icon-theme: set of beautiful icons that can be used with GTK and rofi
flameshot: screenshotting tool

## Step 3

Choose which ever config folders you need ->

awesome, rofi or alacritty 

Copy them inside "home/username/.config"

# How to use / change themes:
When the installation has finished, you need to restart and then from your login screen choose the awesome window manager. You will find a file called "settings.lua" inside "home/username/.config/awesome"
This is where you can configure your awesome settings.

If you want to select a certain theme you can just edit the number inside the brackets "settings.theme[number_here]"
In the following image, theme number 1 is selected

![Theme selection](https://i.imgur.com/EI4Sf5l.png?1)

# Crucial shortcuts
super + ` -> Rofi
super + R -> Restart Awesome
super + Q -> Close/Kill Applications
super + S -> See a cheatsheet of all keybindings

You may change any of these keybindings at any time through the rc.lua config file inside "home/username/.config/awesome"