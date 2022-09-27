#! /bin/bash

# 全局变量，填入项目地址
# HEAD
DIR=$HOME/dotfiles
export git=/usr/bin/git

switch_branch(){
    echo "dir: $DIR"
    # brew_backup
    git checkout -b main > /tmp/tmplog
    if grep -q "fatal: A branch named" /tmp/tmplog ; then
        echo "create new branch"
    else
        echo "checkout to main"
        git checkout main
    fi
}

# > Backup to Github
backup_to_github(){
    msg='Backup on: '`date`
    # echo $msg

    git add $DIR
    git commit -m "$msg"
    git push --set-upstream origin main
    git push
}

switch_branch
# 备份到 github 要最后运行
backup_to_github
exit 0
