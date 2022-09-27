#! /bin/bash

# 全局变量，填入项目地址
# HEAD
DIR=$HOME/dotfiles
export git=/usr/bin/git

# > Backup to Github
backup_to_github(){
    msg='Backup on: '`date`
    # echo $msg

    git add $DIR
    git commit -m "$msg"
    git push --set-upstream origin brew_backup
    git push
}

# 备份到 github 要最后运行
backup_to_github
exit 0
