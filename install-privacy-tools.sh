#!/bin/bash

# Ubuntu Privacy Toolkit Installer – by ChatGPT for Ahmed Ramy

set -e

echo "🔐 Updating system..."
sudo apt update && sudo apt upgrade -y

##########################################
# 1. Tor Browser
##########################################
echo "🌐 Installing Tor Browser..."
cd ~/Downloads
TOR_VERSION="13.0.15"
wget https://www.torproject.org/dist/torbrowser/$TOR_VERSION/tor-browser-linux64-${TOR_VERSION}_ALL.tar.xz
tar -xf tor-browser-linux64-*.tar.xz
mv tor-browser ~/tor-browser
cd ~/tor-browser
./start-tor-browser.desktop --register-app || echo "Tor registered to desktop manually."
cd ~

##########################################
# 2. ProtonVPN GUI
##########################################
echo "🔒 Installing ProtonVPN GUI..."
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://repo.protonvpn.com/debian/public_key.asc | sudo gpg --dearmor -o /etc/apt/keyrings/protonvpn.gpg

echo "deb [signed-by=/etc/apt/keyrings/protonvpn.gpg] https://repo.protonvpn.com/debian stable main" | sudo tee /etc/apt/sources.list.d/protonvpn.list

sudo apt update
sudo apt install -y protonvpn

##########################################
# 3. OpenVPN
##########################################
echo "🔁 Installing OpenVPN (CLI)..."
sudo apt install -y openvpn

##########################################
# 4. Proxychains4
##########################################
echo "🔁 Installing and configuring Proxychains4..."
sudo apt install -y proxychains4

# Backup old config
sudo cp /etc/proxychains4.conf /etc/proxychains4.conf.backup

# Overwrite with Tor config
sudo bash -c 'cat <<EOF > /etc/proxychains4.conf
dynamic_chain
proxy_dns
tcp_read_time_out 15000
tcp_connect_time_out 8000

[ProxyList]
socks5 127.0.0.1 9050
EOF'

##########################################
# 5. Autostart Tor Browser on Login (optional)
##########################################
echo "🔁 Adding Tor Browser to GUI Autostart..."
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/torbrowser.desktop
[Desktop Entry]
Type=Application
Name=Tor Browser
Exec=$HOME/tor-browser/start-tor-browser.desktop
X-GNOME-Autostart-enabled=true
EOF

echo "✅ All privacy tools installed!"
echo "📌 Tools installed:"
echo " - Tor Browser (launch via app menu or autostart)"
echo " - ProtonVPN GUI (menu + CLI)"
echo " - OpenVPN (manual .ovpn)"
echo " - Proxychains4 (use: proxychains4 curl check.torproject.org)"
