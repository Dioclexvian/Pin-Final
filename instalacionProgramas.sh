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
# aws configure  
# aws sts get-caller-identity
export AWS_ACCESS_KEY_ID="AKIA2CUNL3OUIC4M6GOR"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-east-1"
#dos subnets publicas
#llamar ID securitygroup
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --query "SecurityGroups[?GroupName=='ssh y web'].GroupId" | grep "sg-*" | sed 's/"//g')
#llamar ID subnets publicas
PUBLIC1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-1" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g')
PUBLIC2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-4" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g')
PRIVATE1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-2" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g')
PRIVATE2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-3" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g')
#nombre de la cluster-key-??
KEY_NAME=$(aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName" | grep "cluster-key-*" | tail -n 1 | sed 's/"//g')

eksctl create cluster --name eksMundosE --region us-east-1 --node-type t3.micro --nodes 3 --with-oidc --ssh-access --ssh-public-key $KEY_NAME --managed --full-ecr-access --vpc-private-subnets $PRIVATE1,$PRIVATE2 --vpc-public-subnets $PUBLIC1,$PUBLIC2 --vpc-security-group $SECURITY_GROUP_ID
echo "INSTALACIÓN DE CLUSTER CORRECTA"
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer