#!/bin/bash

# Conda Environment Package Installer – by ChatGPT

ENV_NAME="your-env-name"  # 🔁 CHANGE this to your actual environment name

echo "🔁 Activating environment: $ENV_NAME"
source ~/.bashrc
conda activate "$ENV_NAME"

echo "📦 Installing Data Science & AI packages..."
conda install numpy pandas matplotlib seaborn scikit-learn jupyterlab -y
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y

echo "📦 Installing Web and Dev packages..."
conda install requests beautifulsoup4 flask scrapy -y

echo "✅ Packages installed into '$ENV_NAME'. Ready for action!"
