# #!/bin/bash

# # Assuming AWS credentials are set up correctly

# # Create EKS cluster
# eksctl create cluster \
# --name eks-MundosE \
# --version 1.27 \
# --region us-east-1 \
# --nodegroup-name standard-workers \
# --node-type t3.micro \
# --nodes 3 \
# --nodes-min 1 \
# --nodes-max 4 \
# --managed

# # Update kubeconfig
# aws eks --region us-east-1 update-kubeconfig --name eks-MundosE

# # Deploy Nginx
# kubectl create deployment nginx --image=nginx
# kubectl expose deployment nginx --port=80 --type=LoadBalancer

# # Install EBS CSI Driver
# kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# # Install Prometheus
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update
# helm install prometheus prometheus-community/prometheus