#! /bin/bash

if [ -f ".name" ]; then
  backName=$(cat .name)
else
  backName= whoami
fi

backup_folder_path="$HOME/dotfiles/macos/$backName" # 请将 "your_backup_folder_path" 替换为您要检测和创建的文件夹名称
if [ -d "$backup_folder_path" ]; then
  echo "文件夹 $backup_folder_path 已存在"
else
  echo $backup_folder_path
  # mkdir "$backup_folder_path"
  echo "文件夹 $backup_folder_path 已创建"
fi
