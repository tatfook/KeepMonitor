#! /usr/bin/env bash

# remove old version
sudo apt-get remove docker docker-engine docker.io

# apt
#sudo apt-get update
sudo apt-get install \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual

mkdir -p tmp
cd tmp
if [[ ! -f "docker.deb" ]]; then
export {http,https}_proxy=http://www:1234567@192.168.0.200:8282/
# pkg file
wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.2~ce-0~ubuntu-xenial_amd64.deb -O docker.deb
fi

# install
sudo dpkg -i docker.deb

# mirror, need be root
sudo cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]
}
EOF

# restart docker
sudo service docker restart
