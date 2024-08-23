#!/bin/bash

wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

sudo mkdir /data
k3d cluster create -s 1 -a 3 --volume /data:/data

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
kubectl version
echo "source <(kubectl completion bash)" >> ~/.bashrc && source ~/.bashrc

