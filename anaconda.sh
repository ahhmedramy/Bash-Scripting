#!/bin/bash

# Anaconda Installer Script for Ubuntu – by ChatGPT

set -e

echo "📦 Downloading Anaconda installer..."
cd /tmp
wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh

echo "▶️ Running installer..."
bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p $HOME/anaconda3

echo "🔁 Initializing Conda..."
$HOME/anaconda3/bin/conda init
source ~/.bashrc

echo "🖥️ Adding Anaconda auto-start terminal..."
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/anaconda.desktop
[Desktop Entry]
Type=Application
Name=Anaconda
Exec=gnome-terminal -- bash -c "conda activate base; exec bash"
X-GNOME-Autostart-enabled=true
EOF

echo "✅ Anaconda installation complete!"
echo "📌 Restart your terminal or logout/login to activate Conda base environment."
