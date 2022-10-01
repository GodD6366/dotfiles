#! /bin/bash

# 全局变量，填入项目地址
# HEAD
DIR=$HOME/dotfiles/brew
export git=/usr/bin/git

# > Install Homebrew
install_homebrew(){
    if [ `command -v brew` ]; then
        echo '👌 Homebrew 已安装'
    else
        echo '🍺 正在安装 Homebrew... (link to Homebrew: https://brew.sh/)'
        # install script:
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -ne 0 ]; then
            echo '🍻 Homebrew 安装成功'
        else
            echo '🚫 安装失败，请检查你的网络环境，或尝试其他安装方式'
            exit 127
        fi
    fi
}

# > Backup Cask
backup_cask(){
    echo "backing up cask..."
    cd $DIR && brew list --cask > cask.list
    echo "cask: "
    cat $DIR/cask.list
}
# > Backup formulae
backup_formulae(){
    echo "backing up formulae..."
    cd $DIR && brew list --formulae > formulae.list
    echo "formulae: "
    cat $DIR/formulae.list

}

# > Backup Application List
backup_application(){
    echo "backing up application..."
    cd $DIR && ls /Applications | sed s'/\.app$//' > application.list
    echo "application: "
    cat $DIR/application.list
}

# Backup Setapp List
backup_setapp(){
    if [ ! -d /Applications/Setapp ];then
        #echo "setapp directory doesn't exist"
        return 0
    else
        #echo "setapp directory exists"
        echo "backing up setapp..."
        cd $DIR && ls /Applications/Setapp | sed s'/\.app$//' > setapp.list
        echo "setapp: "
        cat setapp.list
    fi
}


# >>  主程序
cd $DIR
# 检查backup 文件夹是否存在
if [ ! -d backup  ];then
  mkdir backup
  DIR=$DIR/backup
else
  DIR=$DIR/backup
fi

# 运行
install_homebrew > /dev/null

# 备份
backup_formulae
backup_cask
backup_application
# backup_setapp
# 备份到 github 要最后运行
# backup_to_github
exit 0
