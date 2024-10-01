#!/bin/bash

sudo apt update -y
sudo apt install awscli -y
sudo apt install curl -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo apt install vlc -y
#curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
#curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
