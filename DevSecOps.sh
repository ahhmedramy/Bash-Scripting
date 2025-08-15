#!/bin/bash

set -e
mkdir -p ~/devsecops-tools
cd ~/devsecops-tools

# Package manager detection
if command -v apt &> /dev/null; then
    INSTALL="sudo apt install -y"
    UPDATE="sudo apt update"
elif command -v dnf &> /dev/null; then
    INSTALL="sudo dnf install -y"
    UPDATE="sudo dnf check-update"
else
    echo "❌ Unsupported system (apt/dnf not found)"
    exit 1
fi

echo "🔄 Updating system..."
$UPDATE

echo "✅ Installing base dependencies..."
$INSTALL git curl wget unzip python3 python3-pip openjdk-17-jdk nodejs npm docker.io jq

# ──────────────────────────────────────────────────────────────
echo "1️⃣ Installing SAST Tools..."
# Semgrep
curl -sL https://semgrep.dev/install.sh | sh
# CodeQL CLI (requires manual config)
echo "➡️ Download CodeQL manually: https://github.com/github/codeql-cli-binaries"
# SonarQube (Docker)
mkdir -p sonar && cd sonar
cat > docker-compose.yml <<EOF
version: '3'
services:
  sonarqube:
    image: sonarqube:community
    ports:
      - "9000:9000"
    environment:
      - SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true
EOF
docker compose up -d
cd ..

# ──────────────────────────────────────────────────────────────
echo "2️⃣ Installing DAST Tools..."
$INSTALL zaproxy nikto
# Burp Suite (Community)
wget -O burpsuite.sh "https://portswigger.net/burp/releases/download?product=community&version=2024.6.1&type=Linux"
chmod +x burpsuite.sh
echo "📌 Run Burp installer manually: ./burpsuite.sh"

# ──────────────────────────────────────────────────────────────
echo "3️⃣ Installing SCA Tools..."
# Trivy
wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.51.1_Linux-64bit.deb
sudo dpkg -i trivy_0.51.1_Linux-64bit.deb
# Snyk
npm install -g snyk
# Dependency-Track (Docker)
mkdir -p dependency-track && cd dependency-track
cat > docker-compose.yml <<EOF
version: '3'
services:
  dtrack:
    image: dependencytrack/bundled
    ports:
      - "8081:8080"
EOF
docker compose up -d
cd ..

# ──────────────────────────────────────────────────────────────
echo "4️⃣ Installing Container Security Tools..."
# Clair and Dockle require manual setup
# Dockle
curl -sSfL https://raw.githubusercontent.com/goodwithtech/dockle/main/install.sh | sh
echo "➡️ Clair setup: https://github.com/quay/clair"

# ──────────────────────────────────────────────────────────────
echo "5️⃣ Installing IaC Security Tools..."
pip install checkov
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
curl -sfL https://raw.githubusercontent.com/Checkmarx/kics/main/scripts/install.sh | sh

# ──────────────────────────────────────────────────────────────
echo "6️⃣ Installing CI/CD Security Tools..."
curl -s https://raw.githubusercontent.com/gitleaks/gitleaks/main/install.sh | bash
# OWASP Dependency-Check
mkdir -p dependency-check && cd dependency-check
curl -L https://github.com/jeremylong/DependencyCheck/releases/latest/download/dependency-check-8.4.0-release.zip -o dc.zip
unzip dc.zip
cd ..

# ──────────────────────────────────────────────────────────────
echo "7️⃣ Installing Kubernetes Security Tools..."
curl -L https://github.com/aquasecurity/kube-bench/releases/latest/download/kube-bench_ubuntu_amd64.tar.gz | tar -xz -C /usr/local/bin
pip install kube-hunter
# Kyverno (via kubectl krew)
if ! command -v kubectl &>/dev/null; then
    echo "⚠️ kubectl is not installed. Kyverno skipped."
else
    kubectl krew install kyverno
fi

# ──────────────────────────────────────────────────────────────
echo "8️⃣ Installing Secrets Detection Tools..."
pip install detect-secrets truffleHog

# ──────────────────────────────────────────────────────────────
echo "9️⃣ Installing Policy/Compliance Tools..."
# OPA
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64 && chmod +x opa && sudo mv opa /usr/local/bin/
# Conftest
curl -L https://github.com/open-policy-agent/conftest/releases/latest/download/conftest_Linux_x86_64.tar.gz | tar -xz -C /usr/local/bin
echo "⚠️ HashiCorp Sentinel is enterprise-only (manual setup)."

# ──────────────────────────────────────────────────────────────
echo "🔟 Installing Observability / SIEM Tools..."
# ELK Stack
$INSTALL elasticsearch logstash kibana
# Falco
curl -s https://raw.githubusercontent.com/falcosecurity/falco/master/scripts/install_falco.sh | sudo bash
echo "➡️ Wazuh and Graylog need manual setup:"
echo "   Wazuh: https://documentation.wazuh.com/current/installation-guide/open-distro/index.html"
echo "   Graylog: https://docs.graylog.org/"

# ──────────────────────────────────────────────────────────────
echo "✅ All available tools have been installed or prepared."
echo "📁 All components are in ~/devsecops-tools/"
echo "🚀 Happy Hacking!"
