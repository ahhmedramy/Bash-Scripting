# Bash‑Scripting‑Installation

Advanced Bash scripting and DevSecOps automation covering SOC tooling, infrastructure hardening, privacy tools, AI environments, and real-world setup labs — including scripts used in KodeKloud e-commerce projects.

> All scripts are self-contained and executable for setting up real environments.

---

## 📜 Scripts Breakdown

### 🔐 DevSecOps & Security

- **DevSecOps-tools.sh**  
  Installs DevSecOps essentials like Trivy, Falco, Grype, and other runtime/container security tools.

- **security-ubuntu.sh**  
  Applies Ubuntu system hardening and installs basic security packages (UFW, fail2ban, auditd, etc.).

- **docker-soc.sh**  
  Deploys a mini SOC stack using Docker (Wazuh, Suricata, Zeek, etc.).

---

### 🧠 AI / MLOps Setup

- **anaconda.sh**  
  Installs Anaconda Python distribution system-wide (data science ready).

- **env-anaconda-pytorch.sh**  
  Sets up a virtual Conda environment with PyTorch pre-installed for ML projects.

- **local.llm.sh**  
  Prepares local LLM dev environment with tools like Ollama, LM Studio, etc.

---

### 🛠️ DevOps & Environment

- **DevOps-setup.sh**  
  Installs Docker, Minikube, kubectl, helm, terraform, and other DevOps toolchain.

- **setup_envs.sh**  
  Configures general environment variables, aliases, and Bash customizations.

---

### 🕵️‍♂️ Pentest & Privacy

- **pentest-tools.sh**  
  Installs essential penetration testing tools (nmap, nikto, sqlmap, etc.).

- **install-privacy-tools.sh**  
  Installs privacy-focused apps like Mullvad, ProtonVPN, Tor, Signal, etc.

---

### 🛡️ SOC Automation

- **soc-install.sh**  
  Automates installation of open-source SIEM/SOC tools on bare metal or VM.

- **tools-help.sh**  
  Companion script providing help commands and usage notes for SOC-related tools.

---

## 🚀 Getting Started

```bash
git clone https://github.com/ahhmedramy/Bash-Scripting-Installation.git
cd Bash-Scripting-Installation
chmod +x <script-name>.sh
./<script-name>.sh
