#!/usr/bin/env bash

# The script creates dev environment on Amazon Linux 2 in AWS WorkSpaces
#
# Usage:
# ./workspaces4dev.sh set

# Env variables: HOME
ZSHRC="${HOME}/.zshrc"

install_code() {
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  yum check-update
  sudo yum -y install code
}

echo_versions() {
  echo "Amazon Linux 2 Packages:"
  aws --version
  git --version
  zsh --version
  jq --version
}

set_zsh() {
  # command -v zsh &> /dev/null || { echo >&2 "I require zsh but it's not installed. Aborting."; exit 1; }
  # sudo yum -y install util-linux-user
  # chsh -s "$(which zsh)" # domain issue
  # if [ "${ZSH_VERSION:-unset}" = "unset" ] ; then
  #   export SHELL=$(which zsh)
  #   # exec /bin/zsh -l
  #   exec /bin/zsh
  # fi
  if ! grep -q "export SHELL.*zsh" "${HOME}/.bashrc"; then
    echo -e "export SHELL=$(which zsh)\n#[ -n \"\$SSH_TTY\" ] && exec \$SHELL\nexec \$SHELL" >> ${HOME}/.bashrc
  fi
}

add_ohmyzsh() {
  echo "Install Oh My Zsh and plugins"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  sed 's/^plugins=(git.*/plugins=(\n\tgit\n\tzsh-autosuggestions\n\tzsh-syntax-highlighting\n)/g' -i ${ZSHRC}
}

powerline_fonts_with_agnoster() {
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo "Set a Powerline monospace font"
  # org.mate.interface monospace-font-name 'Roboto Mono for Powerline 10'
  gsettings set org.mate.interface monospace-font-name "Roboto Mono for Powerline 10"

  echo "Set VSCode to use Powerline Font: 'Roboto Mono for Powerline' > 12"

  echo "Set ZSH_THEME theme to agnoster" 
  sed 's/^ZSH_THEME.*/#ZSH_THEME="robbyrussell"\nZSH_THEME="agnoster"/g' -i ${ZSHRC}

  echo "The prompt could be a little shorter"
  # Backslashes for domain environment
  if ! grep -q "^DEFAULT_USER=" ${ZSHRC}; then
    echo "DEFAULT_USER=$(echo $USERNAME | sed 's/\\/\\\\\\\\/')" >> ${ZSHRC}
  fi
  sed 's/%~/%1~/g' -i ${HOME}/.oh-my-zsh/themes/agnoster.zsh-theme
}

add_tfenv() {
  git clone https://github.com/tfutils/tfenv.git ${HOME}/.tfenv
  if ! grep -q "^export PATH.*tfenv" "${HOME}/.bash_profile"; then
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ${HOME}/.bash_profile
  fi
  # source ${HOME}/.zshrc
  export PATH="$HOME/.tfenv/bin:$PATH"
  tfenv install latest
}

info() {
cat <<EOF
------------------------------------
This script will change your shell when you add \`set\` as a parameter.

What will be changed?
- Your shell will be set to ZSH.
- Oh My Zsh will not make you a 10x developer...but you may feel like one.
- I will set your prompt to super useful and colorful (AWS, Git addons are awesome).
- Will add a VSCode repository and install it.
- Will add tfenv and latest Terraform version

Usage: 
./$(basename $0) set
------------------------------------
EOF
}

if [[ ${1} == "set" ]] 
then
  echo_versions
  install_code
  set_zsh
  add_ohmyzsh
  powerline_fonts_with_agnoster
  add_tfenv
  exec $(which zsh) -l
else
  info
fi
