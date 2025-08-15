#!/bin/bash
set -e

echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing essentials..."
sudo apt install -y wget curl gnupg ca-certificates xclip

echo "📝 Installing Notepad-like editor (Xed)..."
sudo apt install -y xed

echo "📋 Installing CopyQ clipboard manager..."
sudo apt install -y copyq
copyq --start-server

echo "🧠 Installing Shell GPT..."
sudo apt install -y python3 python3-pip
pip install shell-gpt --break-system-packages
echo 'export OPENAI_API_KEY="your_openai_api_key_here"' >> ~/.bashrc

echo "💬 Installing ChatGPT Desktop (Unofficial)..."
sudo apt install -y libwebkit2gtk-4.0-dev libayatana-appindicator3-dev
wget https://github.com/lencx/ChatGPT/releases/download/v0.12.0/ChatGPT_0.12.0_linux_x86_64.deb
sudo apt install -y ./ChatGPT_0.12.0_linux_x86_64.deb
rm ChatGPT_0.12.0_linux_x86_64.deb

echo "🌍 Installing Crow Translate..."
sudo apt install -y crow-translate

echo "⚙️ Setting Crow Translate to autostart..."
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/crow-translate.desktop
[Desktop Entry]
Type=Application
Exec=crow-translate
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Crow Translate
EOF

echo "🧷 Adding global shortcut for Crow Translate..."
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Crow Translate"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "crow-translate"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Control><Alt>e"

echo "🔤 Installing LibreTranslate (DeepL open alternative via Docker)..."
docker run -d -p 5000:5000 libretranslate/libretranslate

echo "🧰 Installing GNOME Tweaks and Extensions..."
sudo apt install -y gnome-tweaks gnome-shell-extensions
sudo apt install -y gnome-shell-extension-system-monitor gnome-shell-extension-appindicator gnome-shell-extension-dash-to-panel

echo "✅ All done! Reboot or log out/in to apply all changes."
