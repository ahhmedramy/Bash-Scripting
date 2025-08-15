#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y curl wget gnupg lsb-release software-properties-common apt-transport-https ca-certificates

echo "🐳 Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🔧 Enabling Docker without sudo..."
sudo groupadd docker || true
sudo usermod -aG docker $USER

echo "💻 Installing GitHub Fork (alternative to GitHub Desktop for Linux)..."
wget -qO - https://release.fork.dev/linux/debs/Fork.deb -O fork.deb
sudo apt install -y ./fork.deb
rm fork.deb

echo "🎮 Installing Discord..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
rm discord.deb

echo "📡 Installing Telegram Desktop..."
sudo apt install -y telegram-desktop

echo "🧠 Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "✅ All apps installed!"
echo "⚠️ Please reboot or log out and back in for Docker group changes to take effect."
