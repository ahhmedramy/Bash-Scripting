#!/bin/bash

# DevOps Tools Setup Script (Ubuntu-based systems)
# Author: Ahmed Ramy
# Description: Installs essential DevOps tools excluding VS Code and VMware.

set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

print_success() {
  echo -e "${GREEN}[✔] $1${NC}"
}

# Update and upgrade system
sudo apt update && sudo apt upgrade -y
print_success "System updated."

# Essential packages
sudo apt install -y curl git wget gnupg2 lsb-release ca-certificates software-properties-common unzip build-essential apt-transport-https
print_success "Essential packages installed."

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \ 
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
print_success "Docker installed. Please reboot or log out and in again to use Docker without sudo."

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
print_success "Docker Compose installed."

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
print_success "kubectl installed."

# Minikube (local Kubernetes cluster)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
print_success "Minikube installed."

# Terraform
sudo apt install -y gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
print_success "Terraform installed."

# Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
print_success "Ansible installed."

# Helm (Kubernetes package manager)
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | \
  sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install -y helm
print_success "Helm installed."

# Jenkins (Optional - Uncomment if needed)
# curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \ 
#   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
# echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \ 
#   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \ 
#   /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt update
# sudo apt install -y openjdk-17-jdk jenkins
# print_success "Jenkins installed."

# Optional: Install Zsh and Oh-My-Zsh
# sudo apt install -y zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# print_success "Zsh & Oh-My-Zsh installed."

print_success "DevOps setup completed. Some tools may require restarting the terminal or system."
