#!/bin/bash

# Ask for sudo once
if [ "$EUID" -ne 0 ]; then
  echo "[!] Please run as root (e.g. sudo ./devops-setup.sh)"
  exit
fi

# Update package list
apt update && apt upgrade -y

# Define installer functions

install_core_devops_tools() {
  echo "[*] Installing Core DevOps Tools..."
  apt install -y git curl wget htop tree unzip zip jq yq net-tools nmap tmux neofetch
}

install_containers_and_k8s() {
  echo "[*] Installing Docker + Kubernetes tools..."

  # Docker
  apt install -y ca-certificates gnupg lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list

  apt update
  apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  usermod -aG docker $SUDO_USER

  # Kubernetes tools
  curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl

  curl -Lo k9s.tar.gz https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
  tar -xzf k9s.tar.gz && mv k9s /usr/local/bin && rm k9s.tar.gz

  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
}

install_iac_stack() {
  echo "[*] Installing Terraform + Ansible + Cloud CLIs..."

  # Terraform
  curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list
  apt update && apt install -y terraform

  # Ansible
  apt install -y ansible

  # Terragrunt
  curl -Lo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64
  chmod +x /usr/local/bin/terragrunt

  # AWS CLI
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
  unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip aws

  # Azure CLI
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash

  # Google Cloud SDK
  apt install -y apt-transport-https ca-certificates gnupg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | gpg --dearmor > /usr/share/keyrings/cloud.google.gpg
  apt update && apt install -y google-cloud-cli
}

install_ci_cd_stack() {
  echo "[*] Installing CI/CD Tools..."

  # Jenkins
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list
  apt update && apt install -y openjdk-17-jdk jenkins

  # GitHub CLI
  type -p curl >/dev/null || apt install curl -y
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list
  apt update && apt install gh -y

  # act (GitHub Actions runner)
  curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | bash

  # GitLab Runner
  curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash
  apt install -y gitlab-runner
}

# Menu
while true; do
  echo ""
  echo "========== DevOps Installer =========="
  echo "1) Core DevOps Tools"
  echo "2) Docker + Kubernetes"
  echo "3) Terraform + IaC Stack"
  echo "4) CI/CD Stack"
  echo "5) Exit"
  read -p "Choose an option [1-5]: " choice

  case $choice in
    1) install_core_devops_tools ;;
    2) install_containers_and_k8s ;;
    3) install_iac_stack ;;
    4) install_ci_cd_stack ;;
    5) echo "Goodbye!" && exit ;;
    *) echo "[!] Invalid option." ;;
  esac
done
