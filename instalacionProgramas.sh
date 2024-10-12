#!/bin/bash

sudo apt update -y
sudo apt install awscli -y
sudo apt install curl -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
echo "HASTA AQUÍ TODO BIEN"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "INSLATACIÓN DE HELM CORRECTA"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
echo "INSTALACIÓN DE EKSCTL CORRECTA"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "INSTALACIÓN DE KUBECTL CORRETA %%%%%%%%%"
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --group-names pinFinalSG --region us-east-1 --query "SecurityGroups[0].GroupId" --output text)
echo "El ID del grupo de seguridad es: $SECURITY_GROUP_ID"
eksctl create cluster --name eksMundosE --region us-east-1 --node-type t3.micro --nodes 3 --with-oidc --ssh-access --ssh-public-key cluster-key-* --managed --full-ecr-access --zones us-east-1a, us-east-1b, us-east-1c --vpc-private-subnets subnet_private1,subnet_private2 --vpc-public-subnets subnet_public 
#--vpc-security-group $SECURITY_GROUP_ID
ECHO "INSTALACIÓN DE CLUSTER CORRECTA"
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer