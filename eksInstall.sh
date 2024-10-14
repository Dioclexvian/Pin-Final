#!bin/bash
# aws configure  
# aws sts get-caller-identity
export AWS_ACCESS_KEY_ID=" "
export AWS_SECRET_ACCESS_KEY=" "
export AWS_DEFAULT_REGION="us-east-1"

# export SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --query "SecurityGroups[?GroupName=='ssh y web'].GroupId" | grep "sg-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
# export PUBLIC1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-1" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
# export PUBLIC2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-5" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
# export PUBLIC3=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-6" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
# export PRIVATE1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-2" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
# export PRIVATE2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-3" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
# export PRIVATE3=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=grupo10-sub-4" --query "Subnets[].SubnetId" | grep "subnet-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')
export KEY_NAME=$(aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName" | grep "cluster-key-*" |tail -n 1| sed 's/"//g; s/,//g; s/[[:space:]]//g')
# export VPC_NAME=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=grupo10" --query "Vpcs[].VpcId" | grep "vpc-*" | sed 's/"//g; s/,//g; s/[[:space:]]//g')

#crear ambos archivos
# envsubst < cluster-config-template.yaml > cluster-config.yaml
# eksctl create cluster -f cluster-config.yaml
eksctl create cluster --name eksMundosE --region us-east-1 --node-type t3.small --nodes 3 --with-oidc --ssh-access --ssh-public-key $KEY_NAME --managed --full-ecr-access --zones us-east-1a,us-east-1b,us-east-1c

kubectl get nodes
kubectl get pods

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

kubectl  get svc nginx
curl http://<ip>

git clone https://github.com/kubernetes-sigs/aws-ebs-csi-driver.git
cd aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr
kubectl apply -k .

kubectl get pods -n kube-system -l app=ebs-csi-controller

prometeus

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace prometheus
helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"

