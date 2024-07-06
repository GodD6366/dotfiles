#! /bin/bash

if [ -f ".name" ]; then
  backName=$(cat .name)
else
  backName= whoami
fi
    echo "Backup ~/.zshrc to ~/dotfiles/macos/$backName/zshrc"
