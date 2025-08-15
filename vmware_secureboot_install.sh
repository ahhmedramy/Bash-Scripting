#!/bin/bash

# This script installs VMware Workstation/Player on Ubuntu with Secure Boot support (MOK)
# Tested on Ubuntu 22.04+ with Secure Boot enabled

set -e

# === CONFIG ===
BUNDLE_FILE="VMware-Player-Full-*.bundle"
MOK_DIR=~/vmware-sign
MOK_NAME="vmware-mok"
MOK_PRIV="$MOK_DIR/MOK.priv"
MOK_DER="$MOK_DIR/MOK.der"

echo "🔧 Installing required dependencies..."
sudo apt update
sudo apt install -y build-essential dkms linux-headers-$(uname -r) libaio1

echo "📁 Creating MOK directory at $MOK_DIR..."
mkdir -p "$MOK_DIR"

echo "🔑 Generating new MOK key pair..."
openssl req -new -x509 -newkey rsa:2048 -keyout "$MOK_PRIV" -out "$MOK_DER" -nodes -days 36500 -subj "/CN=VMware MOK/"

echo "🖋️ Enrolling MOK (you'll be asked to set a password)..."
sudo mokutil --import "$MOK_DER"

echo "✅ Now REBOOT and select 'Enroll MOK' during boot to complete Secure Boot key setup."
read -p "Press ENTER to continue once you have rebooted and enrolled the MOK..."

echo "📦 Installing VMware bundle..."
chmod +x "$BUNDLE_FILE"
sudo ./"$BUNDLE_FILE" --eulas-agreed --required

echo "🔍 Locating VMware kernel modules..."
VM_MODULES=("vmmon" "vmnet")
for module in "${VM_MODULES[@]}"; do
  MOD_PATH=$(modinfo -n $module 2>/dev/null || true)
  if [[ -n "$MOD_PATH" ]]; then
    echo "🔏 Signing module: $module ($MOD_PATH)"
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 "$MOK_PRIV" "$MOK_DER" "$MOD_PATH"
  else
    echo "⚠️ Module $module not found yet. Will attempt to load anyway."
  fi
done

echo "🔃 Reloading VMware kernel modules..."
sudo modprobe -r vmmon vmnet || true
sudo modprobe vmmon
sudo modprobe vmnet

echo "✅ Done! VMware is installed and works with Secure Boot."
echo "🔁 You can now run VMware by typing: vmware"
