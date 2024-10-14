# #!/bin/bash

# # Update and upgrade
# sudo apt update && sudo apt-get upgrade -y
# sudo apt install awscli -y
# sudo apt install curl -y

# # Install Docker
# sudo apt install -y docker.io
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo usermod -aG docker ubuntu

# # Install Helm
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh

# echo "INSLATACIÓN DE HELM CORRECTA"
# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# sudo mv /tmp/eksctl /usr/local/bin
# echo "INSTALACIÓN DE EKSCTL CORRECTA"
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# echo "INSTALACIÓN DE KUBECTL CORRECTA"