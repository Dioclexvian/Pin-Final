#!bin/bash
# aws configure  
# aws sts get-caller-identity
export AWS_ACCESS_KEY_ID="" 
export AWS_SECRET_ACCESS_KEY="" 
export AWS_DEFAULT_REGION="us-east-1"
#dos subnets publicas
#llamar ID securitygroup
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --query "SecurityGroups[?GroupName=='ssh y web'].GroupId" | grep "sg-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
#llamar ID subnets publicas
PUBLIC1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-1" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
PUBLIC2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-5" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
PUBLIC3=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-6" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
PRIVATE1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-2" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
PRIVATE2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-3" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
PRIVATE3=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-4" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
#nombre de la cluster-key-??
KEY_NAME=$(aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName" | grep "cluster-key-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')


#eksctl create cluster --name eksMundosE --region us-east-1 --node-type t3.micro --nodes 3 --with-oidc --ssh-access --ssh-public-key $KEY_NAME --managed --full-ecr-access --zones us-east-1a,us-east-1b,us-east-1c
eksctl create cluster -f cluster-config.yaml


echo "INSTALACIÓN DE CLUSTER CORRECTA"
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer