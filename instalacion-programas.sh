#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
              
#awscli
sudo apt install awscli -y

#kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

#helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash


