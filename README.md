# Make AWS WorkSpaces Dev friendly

Here is a script that makes some changes to Amazon Linux 2 running in Amazon 
WorkSpaces. 

Is is a early development version (still testing).


## Features
- Inslall VSCode repo and editor
- Set ZSH shell
- Add Oh My Zsh framework, plugins.
- Install Powerline fonts and configure
- Add `tfenv`


## Feel
Look into embedded terminal. Minimal prompt wit maximum useful things. Such as 
AWS profile information, Git repo info, ZSH interactive history search...

![screen]


## Usage

Get the script
```sh
curl -L https://raw.githubusercontent.com/loopold/aws-workspaces/workspaces4dev.sh
```
If you are absolutely sure run it with `set` parameter. Without the parameter,
you'll receive info about the system changes that the script will make.
```sh
/workspaces4dev.sh set
```

[screen]: ./workspaces-screen.png