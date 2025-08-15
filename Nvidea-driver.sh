#!/bin/bash

# NVIDIA RTX 3070 Setup for Legion 5 Pro – by ChatGPT

set -e

echo "🧹 Removing old NVIDIA drivers..."
sudo apt-get purge '^nvidia-.*' -y
sudo apt-get autoremove -y
sudo rm -f /etc/X11/xorg.conf

echo "🔍 Detecting available NVIDIA drivers..."
sudo apt update
sudo ubuntu-drivers devices

echo "📦 Installing recommended NVIDIA driver..."
sudo ubuntu-drivers autoinstall

echo "⚙️ Installing NVIDIA settings tool..."
sudo apt install -y nvidia-settings

echo "📦 Installing CUDA Toolkit..."
sudo apt install -y nvidia-cuda-toolkit

echo "📦 Installing Vulkan utilities..."
sudo apt install -y vulkan-utils

echo "📦 Installing NVENC encoding support..."
sudo apt install -y libnvidia-encode-535

echo "🧪 Verifying NVIDIA installation..."
echo "---------------- nvidia-smi ----------------"
nvidia-smi || echo "❌ nvidia-smi failed – reboot may be required"
echo "---------------- prime-select --------------"
prime-select query || echo "❌ prime-select error"

echo "🔧 Switching GPU to NVIDIA (prime-select)..."
sudo prime-select nvidia

echo "✅ Setup complete."
read -p "⚠️ Reboot is required. Reboot now? (y/n): " choice
if [[ "$choice" == "y" ]]; then
    sudo reboot
else
    echo "❗ Please reboot manually later to apply changes."
fi
