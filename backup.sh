#! /bin/bash

DIR=$HOME/dotfiles
export git=/usr/bin/git

# backup my config
backup() {
    echo "Backup ~/.zshrc to ~/dotfiles/macos/$(whoami)/zshrc"
    cp ~/.zshrc ~/dotfiles/macos/$(whoami)/zshrc

    echo "Backup brew bundle to ~/dotfiles/macos/$(whoami)/Brewfile"
    brew bundle dump --describe --force --no-upgrade --file="~/dotfiles/macos/$(whoami)/Brewfile"

    # echo "Backup brew to ~/dotfiles/brew/backup"
    # sh -c $HOME/dotfiles/brew/backup.sh

    # code --list-extensions > ~/dotfiles/_rc/exts.txt
}

# > Backup to Github
backup_to_github(){
    msg='Backup on: '`date`
    # echo $msg
    cd $DIR

    if [ -n "$(git status -s)" ];then
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
