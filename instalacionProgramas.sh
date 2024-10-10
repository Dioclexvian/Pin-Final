#!/bin/bash

sudo apt update -y
sudo apt install awscli -y
sudo apt install curl -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo apt install curl -y

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Instalar eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin


# Crear cluster EKS
eksctl create cluster \
--name eks-mundos-e \
--region us-east-1 \
--node-type t3.micro \
--nodes 3 \
--with-oidc \
--ssh-access \
--ssh-public-key cluster-key-* \
--managed \
--full-ecr-access \
--zones us-east-1a,us-east-1b,us-east-1c \
--vpc-private-subnets subnet_private1, subnet_private1 \
--vpc-private-subnets subnet_public

# Desplegar pod de nginx
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer