#!/bin/bash

# DevSecOps Tools Installer by Ahmed Ramy
# Categories: SAST, DAST, SCA, Container Security, IaC, CI/CD Security, K8s Security, Secrets Detection, Compliance, Observability

set -e

# Detect OS
if command -v apt &> /dev/null; then
    PM="apt"
    INSTALL="apt install -y"
    UPDATE="apt update -y"
elif command -v dnf &> /dev/null; then
    PM="dnf"
    INSTALL="dnf install -y"
    UPDATE="dnf check-update"
elif command -v pacman &> /dev/null; then
    PM="pacman"
    INSTALL="pacman -S --noconfirm"
    UPDATE="pacman -Syu"
else
    echo "❌ Unsupported package manager"
    exit 1
fi

echo "🔄 Updating system..."
sudo $UPDATE

echo "📘 1. Installing SAST Tools..."
sudo $INSTALL git curl jq
# Semgrep
curl -sL https://semgrep.dev/install.sh | sh
# CodeQL (requires GitHub CLI setup)
echo "➡️ CodeQL: https://github.com/github/codeql-cli-binaries/releases"
# SonarQube (requires Java, setup manually)
echo "➡️ SonarQube: https://www.sonarsource.com/products/sonarqube/downloads/"

echo "🌐 2. Installing DAST Tools..."
sudo $INSTALL zaproxy nikto
echo "➡️ Burp Suite: Download Community Edition manually: https://portswigger.net/burp"

echo "📦 3. Installing SCA Tools..."
# Trivy (also used for container scan)
sudo apt install wget -y
wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.51.1_Linux-64bit.deb -O trivy.deb && sudo dpkg -i trivy.deb
# Snyk (requires login)
npm install -g snyk
# Dependency-Track is web app, needs Docker or manual: https://github.com/DependencyTrack/dependency-track

echo "🐳 4. Installing Container Security Tools..."
sudo $INSTALL docker.io docker-compose
# Clair setup: https://github.com/quay/clair
# Dockle
curl -sSfL https://raw.githubusercontent.com/goodwithtech/dockle/main/install.sh | sh

echo "📜 5. Installing IaC Security Tools..."
# Checkov
pip install checkov
# tfsec
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
# KICS
curl -sfL https://raw.githubusercontent.com/Checkmarx/kics/main/scripts/install.sh | sh

echo "⚙️ 6. Installing CI/CD Security Tools..."
# Gitleaks
curl -s https://raw.githubusercontent.com/gitleaks/gitleaks/main/install.sh | bash
# OWASP Dependency-Check
sudo mkdir -p /opt/dependency-check && cd /opt/dependency-check
curl -L https://github.com/jeremylong/DependencyCheck/releases/download/v8.4.0/dependency-check-8.4.0-release.zip -o dc.zip && unzip dc.zip
# GitHub Advanced Security: Enterprise feature, skip

echo "☸️ 7. Installing Kubernetes Security Tools..."
# kube-bench
curl -L https://github.com/aquasecurity/kube-bench/releases/latest/download/kube-bench_ubuntu_amd64.tar.gz | tar -xz -C /usr/local/bin
# kube-hunter
pip install kube-hunter
# Kyverno (requires kubectl)
kubectl krew install kyverno || echo "➡️ Install Krew first: https://krew.sigs.k8s.io/docs/user-guide/setup/install/"

echo "🔐 8. Installing Secrets Detection Tools..."
# detect-secrets
pip install detect-secrets
# truffleHog
pip install truffleHog

echo "📏 9. Installing Compliance/Policy as Code Tools..."
# OPA
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod +x opa && sudo mv opa /usr/local/bin/
# Conftest
curl -L https://github.com/open-policy-agent/conftest/releases/latest/download/conftest_Linux_x86_64.tar.gz | tar -xz -C /usr/local/bin
# Sentinel is closed-source (HashiCorp Enterprise)

echo "📊 10. Installing Observability/SIEM Tools..."
# ELK Stack (manual for full setup)
sudo $INSTALL elasticsearch logstash kibana
# Wazuh & Graylog can be installed manually
# Falco
curl -s https://raw.githubusercontent.com/falcosecurity/falco/master/scripts/install_falco.sh | sudo bash

echo "✅ All available tools have been processed. Manual setup may be needed for some tools."
