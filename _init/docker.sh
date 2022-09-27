#!/bin/sh

echo "创建名为docker的组"
sudo groupadd docker

echo "将当前用户加入组docker"
sudo gpasswd -a ${USER} docker

echo "重启docker服务"
sudo systemctl restart docker

echo "添加访问和执行权限"
sudo chmod a+rw /var/run/docker.sock