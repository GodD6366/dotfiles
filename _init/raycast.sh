#!/bin/bash

rm -rf ~/dotfiles/lib
# mkdir lib

cp -r ~/dotfiles/macos/raycast ~/dotfiles/lib

# 获取 node 地址
CURRENT_NODE_PATH=$(which node)

echo $CURRENT_NODE_PATH

sed -i "" "s?CURRENT_NODE_PATH?"$CURRENT_NODE_PATH"?" ~/dotfiles/lib/fanyi.js
sed -i "" "s?CURRENT_NODE_PATH?"$CURRENT_NODE_PATH"?" ~/dotfiles/lib/timeParser.js
sed -i "" "s?CURRENT_NODE_PATH?"$CURRENT_NODE_PATH"?" ~/dotfiles/lib/cdn.js

exit 0
