#!bin/bash
# aws configure  
# aws sts get-caller-identity
export AWS_ACCESS_KEY_ID="${SECRET_KEY}"
export AWS_SECRET_ACCESS_KEY="${ANOTHER_SECRET}"
export AWS_DEFAULT_REGION="us-east-1"

export SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --query "SecurityGroups[?GroupName=='ssh y web'].GroupId" | grep "sg-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export PUBLIC1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-1" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export PUBLIC2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-5" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export PUBLIC3=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-6" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export PRIVATE1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-2" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export PRIVATE2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-3" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export PRIVATE3=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-4" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export KEY_NAME=$(aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName" | grep "cluster-key-*" |tail -n 1| sed 's/"//g; s/,//g; s/[[:space:]]//g')
export VPC_NAME=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=grupo10" --query "Vpcs[].VpcId" | grep "vpc-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')

#crear ambos archivos
envsubst < cluster-config-template.yaml > cluster-config.yaml
#eksctl create cluster --name eksMundosE --region us-east-1 --node-type t3.micro --nodes 3 --with-oidc --ssh-access --ssh-public-key $KEY_NAME --managed --full-ecr-access --zones us-east-1a,us-east-1b,us-east-1c
eksctl create cluster -f cluster-config.yaml


echo "INSTALACIÓN DE CLUSTER CORRECTA"
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer