#! /bin/bash

DIR=$HOME/dotfiles
export git=/usr/bin/git

if [ -f ".name" ]; then
  backName=$(cat .name)
else
  backName=$(whoami)
fi

backup_folder_path="$HOME/dotfiles/macos/$backName"
if [ -d "$backup_folder_path" ]; then
  echo "文件夹 $backup_folder_path 已存在"
else
  mkdir "$backup_folder_path"
  echo "文件夹 $backup_folder_path 已创建"
fi

# backup my config
backup() {
  echo "Backup ~/.zshrc to $backup_folder_path/zshrc"
  cp ~/.zshrc $backup_folder_path/zshrc

  echo "Backup brew bundle to $backup_folder_path/Brewfile"
  # 暂时不列出 --whalebrew --vscode
  brew bundle dump --describe --force --no-upgrade --brews --casks --taps --mas --file="$backup_folder_path/Brewfile"

  # echo "Backup brew to ~/dotfiles/brew/backup"
  # sh -c $HOME/dotfiles/brew/backup.sh

  # code --list-extensions > ~/dotfiles/_rc/exts.txt
}

# > Backup to Github
backup_to_github() {
  msg='Backup on: '$(date)
  # echo $msg
  cd $DIR

  if [ -n "$(git status -s)" ]; then
    git pull --rebase
    git add $DIR/macos
    git commit -m "$msg"
    git push --set-upstream origin main
    git push
  fi
}

# 备份
backup
# 备份到 github 要最后运行
backup_to_github

exit 0
