#!/bin/bash

# Secure Ubuntu Script – by ChatGPT for ahmed ramy

set -e

echo "🛠️ Updating system..."
sudo apt update && sudo apt upgrade -y

echo "🧱 Installing and configuring UFW Firewall..."
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
sudo ufw status verbose

echo "🛡️ Installing Fail2Ban..."
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Optional: you can tune jails in /etc/fail2ban/jail.local

echo "🧪 Installing ClamAV Antivirus..."
sudo apt install clamav clamav-daemon -y
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam
sudo systemctl enable clamav-freshclam

echo "🧼 Creating daily antivirus scan (ClamAV)..."
echo "0 3 * * * root clamscan -r --bell -i / > /var/log/clamav/daily-scan.log" | sudo tee /etc/cron.d/clamav-scan

echo "🔍 Installing RKHunter (Rootkit Scanner)..."
sudo apt install rkhunter -y
sudo rkhunter --update
sudo rkhunter --propupd -y
sudo rkhunter --check --sk

echo "🧼 Creating weekly rootkit scan (RKHunter)..."
echo "0 4 * * 0 root /usr/bin/rkhunter --check --sk > /var/log/rkhunter.log" | sudo tee /etc/cron.weekly/rkhunter-scan
sudo chmod +x /etc/cron.weekly/rkhunter-scan

echo "🔎 Installing Lynis (Security Auditor)..."
sudo apt install lynis -y

echo "🧼 Creating monthly Lynis audit..."
echo "0 5 1 * * root /usr/bin/lynis audit system > /var/log/lynis-monthly.log" | sudo tee /etc/cron.monthly/lynis-audit
sudo chmod +x /etc/cron.monthly/lynis-audit

echo "✅ All tools installed and scheduled."

echo "📂 LOG LOCATIONS:"
echo " - ClamAV: /var/log/clamav/daily-scan.log"
echo " - RKHunter: /var/log/rkhunter.log"
echo " - Lynis: /var/log/lynis-monthly.log"

echo "🔐 Ubuntu is now secured 🎯"
