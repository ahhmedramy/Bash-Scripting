#!/bin/bash

# Cybersecurity Toolkit Installer by Ahmed Ramy
# Categories: SIEM, EDR, Network Monitoring, Threat Intel, Forensics, Log Management, Honeypots, SOAR

set -e

# Detect OS and set package manager
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
    echo "Unsupported package manager"
    exit 1
fi

echo "🛠️ Updating system..."
sudo $UPDATE

echo "🔐 Installing SIEM tools..."
sudo $INSTALL filebeat logstash kibana elasticsearch
sudo $INSTALL graylog-server || true
sudo $INSTALL wazuh-manager wazuh-agent || true
sudo $INSTALL splunk || echo "➡️ Splunk requires manual download from https://www.splunk.com"

echo "🛡️ Installing EDR / Host Monitoring tools..."
sudo $INSTALL ossec-hids
sudo $INSTALL sysmonforlinux || echo "➡️ Install Sysmon manually for Linux: https://github.com/Sysinternals/SysmonForLinux"
sudo $INSTALL velociraptor || echo "➡️ Install Velociraptor manually: https://www.velociraptor.app"

echo "🌐 Installing Network IDS/IPS tools..."
sudo $INSTALL zeek suricata snort
sudo $INSTALL nload nethogs
sudo $INSTALL securityonion || echo "➡️ Security Onion requires custom ISO or manual install"
sudo $INSTALL ntopng

echo "🕵️ Installing Threat Intelligence platforms..."
sudo $INSTALL misp || echo "➡️ MISP install: https://misp.github.io/MISP/"
sudo $INSTALL opencti || echo "➡️ OpenCTI manual: https://www.opencti.io/"
sudo $INSTALL thehive || echo "➡️ TheHive install guide: https://thehive-project.org/"
sudo $INSTALL yeti || echo "➡️ Yeti install: https://github.com/yeti-platform/yeti"
sudo $INSTALL curl jq && curl -s https://threatfox.abuse.ch/downloads/json/ | jq . > /dev/null && echo "✅ ThreatFox accessed."

echo "🔬 Installing Forensics / IR tools..."
sudo $INSTALL autopsy volatility3 plaso log2timeline sleuthkit
sudo $INSTALL cyberchef || echo "➡️ CyberChef web: https://gchq.github.io/CyberChef/"
sudo $INSTALL kape || echo "➡️ KAPE by Kroll is Windows only: https://www.kroll.com/en/services/cyber-risk/incident-response-litigation-support/kroll-artifact-parser-extractor-kape"

echo "📦 Installing Log Shippers..."
sudo $INSTALL filebeat logstash fluentd rsyslog

echo "🎣 Installing Honeypots..."
sudo $INSTALL cowrie || echo "➡️ Cowrie install: https://github.com/cowrie/cowrie"
sudo $INSTALL dionaea || echo "➡️ Dionaea: https://github.com/DinoTools/dionaea"
sudo $INSTALL honeyd || echo "➡️ Honeyd is old and may need manual install"
sudo $INSTALL tpot || echo "➡️ T-Pot: https://github.com/telekom-security/tpotce"

echo "🤖 Installing SOAR / Automation Tools..."
sudo $INSTALL shuffle || echo "➡️ Shuffle: https://shuffler.io"
sudo $INSTALL cortex || echo "➡️ Cortex: https://github.com/TheHive-Project/Cortex"
sudo $INSTALL stackstorm || echo "➡️ StackStorm install: https://docs.stackstorm.com"

echo "✅ All available tools processed. Check output above for tools requiring manual setup."
