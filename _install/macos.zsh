#!/bin/zsh

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "No macOS detected!"
  exit 1
fi

start() {
  clear
  echo -n "* The setup will begin in 5 seconds... "

  sleep 5

  echo -n "Times up! Here we start!"
  echo ""

  cd $HOME
}

# xcode command tool will be installed during homebrew installation
install_homebrew() {
  echo "==========================================================="
  echo "                     Install Homebrew                      "
  echo "-----------------------------------------------------------"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_packages() {
  # Only install required packages for setting up enviroments
  # Later we will call brew bundle
  __pkg_to_be_installed=(
    curl
    fnm
    git
    jq
    wget
    zsh
    thefuck
    mas
  )

  echo "==========================================================="
  echo "* Install following packages:"
  echo ""

  for __pkg ($__pkg_to_be_installed); do
    echo "  - ${__pkg}"
  done

  echo "-----------------------------------------------------------"

  brew update

  for __pkg ($__pkg_to_be_installed); do
    brew install ${__pkg} || true
  done
}

clone_repo() {
  echo "-----------------------------------------------------------"
  echo "* Cloning GodD/dotfiles Repo from GitHub.com"
  echo "-----------------------------------------------------------"

  git clone https://github.com/GodD6366/dotfiles.git

  cd ./dotfiles
#   rm -rf .git
}

setup_omz() {
  echo "==========================================================="
  echo "                      Shells Enviroment"
  echo "-----------------------------------------------------------"
  echo "* Installing Oh-My-Zsh..."
  echo "-----------------------------------------------------------"

  curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

  echo "-----------------------------------------------------------"
  echo "* Installing ZSH Custom Plugins & Themes:"
  echo ""
  echo "  - zsh-autosuggestions"
  echo "  - fast-syntax-highlighting"
  echo "  - zsh-gitcd"
  echo "  - spaceship zsh-theme"
  echo "  - zsh-z"
  echo "-----------------------------------------------------------"


  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zdharma/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H
  git clone https://github.com/mafredri/zsh-async.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-async
  git clone https://github.com/sukkaw/zsh-gitcd.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-gitcd
  git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-z

#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  echo "安装 spaceship 主题"
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt --depth=1
  ln -s ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme

}

brew_bundle() {
  brew bundle --file="~/dotfiles/macos/$(whoami)/Brewfile"
}

install_nodejs() {
  echo "==========================================================="
  echo "              Setting up NodeJS Environment"

  eval $(fnm env --shell zsh)
  fnm install --lts

  # Set NPM Global Path
  export NPM_CONFIG_PREFIX="$HOME/.npm-global"
  # Create .npm-global folder if not exists
  [[ ! -d "$NPM_CONFIG_PREFIX" ]] && mkdir -p $NPM_CONFIG_PREFIX

  echo "-----------------------------------------------------------"
  echo "* Installing NodeJS LTS..."
  echo "-----------------------------------------------------------"

  fnm install --lts

  echo "-----------------------------------------------------------"
  echo -n "* NodeJS Version: "

  node -v

  __npm_global_pkgs=(
    @cloudflare/wrangler
    @upimg/cli
    0x
    cf-firewall-rules-generator
    # clinic
    hexo-cli
    ipip-cli
    nali-cli@next
    vercel
    npm-why
    # pnpm
    npm
    # posea
    serve
    # surge
    yarn
  )

  echo "-----------------------------------------------------------"
  echo "* npm install global packages:"
  echo ""

  for __npm_pkg ($__npm_global_pkgs); do
    echo "  - ${__npm_pkg}"
  done

  echo "-----------------------------------------------------------"

  for __npm_pkg ($__npm_global_pkgs); do
    npm i -g ${__npm_pkg}
  done
}

install-goenv() {
  echo "==========================================================="
  echo "                   Install syndbg/goenv"
  echo "-----------------------------------------------------------"

  git clone https://github.com/syndbg/goenv.git $HOME/.goenv
}

ci_editor() {
  echo "==========================================================="
  echo "                Install Google ci_editor"
  echo ""
  echo "* Cloning google/ci_edit from GitHub.com"
  echo "-----------------------------------------------------------"

  cd $HOME
  git clone https://github.com/google/ci_edit.git --depth=5

  echo "-----------------------------------------------------------"
  echo "> You can run 'ci-edit-update' later to finish install."

  sleep 5
}

zshrc() {
  echo "==========================================================="
  echo "                  Import GodD env zshrc                   "
  echo "-----------------------------------------------------------"

  cat $HOME/dotfiles/_zshrc/macos.zshrc > $HOME/.zshrc
#   cat $HOME/dotfiles/p10k/.p10k.zsh > $HOME/.p10k.zsh
}

fix_home_end_keybinding() {
  mkdir -p $HOME/Library/KeyBindings/
  echo "{
    \"\UF729\"  = moveToBeginningOfLine:; // home
    \"\UF72B\"  = moveToEndOfLine:; // end
    \"$\UF729\" = moveToBeginningOfLineAndModifySelection:; // shift-home
    \"$\UF72B\" = moveToEndOfLineAndModifySelection:; // shift-end
  }" > $HOME/Library/KeyBindings/DefaultKeyBinding.dict
}

finish() {
  echo "==========================================================="
  echo -n "* Clean up..."

  cd $HOME
#   rm -rf $HOME/dotfiles

  echo "Done!"
  echo ""
  echo "> GodD Enviroment Setup finished!"
  echo "> Do not forget run those things:"
  echo ""
  echo "- chsh -s /bin/zsh  # 切换默认终端"
  echo "- git-config        # 初始化 git 配置"
  echo "- backup_mac        # 备份 mac 软件"
  echo "- recover_mac       # 恢复 mac 软件"
  echo "- npm login         # 登录 npm"
  echo "- ci-edit-update    # 初始化编辑器"
  echo ""
  echo "==========================================================="

  cd $HOME
}

start
install_homebrew
install_packages
clone_repo
setup_omz
brew_bundle
install_nodejs
ci_editor
fix_home_end_keybinding
zshrc
finish