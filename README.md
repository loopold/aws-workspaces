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
Take a look at the embedded terminal. Minimal prompt with maximum useful things. 
Such as AWS profile information, Git repo info, ZSH interactive history search...

![screen]


## Usage
Get the script
```sh
curl -OL https://raw.githubusercontent.com/loopold/aws-workspaces/master/workspaces4dev.sh
```
If you are absolutely sure run it with `set` parameter. Without the parameter,
you'll receive info about the system changes that the script will make.
```sh
chmod +x workspaces4dev.sh
./workspaces4dev.sh set
```

## Post-config
I strongly suggest changing Mate theme to Arc-Dark (`Control Center` > `Look and Feel` > 
`Apperance`). It seems my `gsettings` command in the script is not doing its job yet.

Please set VSCode to use Powerline Font: 'Roboto Mono for Powerline'. Size 12.
Set it in app preferences or put code below into the file `~/.config/Code/User/settings.json`
```json
{
    "editor.fontFamily": "'Roboto Mono for Powerline'",
    "editor.fontSize": 12
}
```


[screen]: ./workspaces-screen.png