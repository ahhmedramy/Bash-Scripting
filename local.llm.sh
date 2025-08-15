#!/bin/bash

# === Basic Setup ===
echo "[*] Installing Python3 venv and git..."
sudo apt update
sudo apt install -y python3-venv git

echo "[*] Cloning oobabooga/text-generation-webui..."
git clone https://github.com/oobabooga/text-generation-webui.git
cd text-generation-webui

echo "[*] Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate

echo "[*] Installing requirements..."
pip install -r requirements.txt

# === Ask for Model ===
read -p "Enter your model folder name (inside models/): " MODEL_NAME
read -p "Enter your model filename (.gguf): " MODEL_FILE

# === OPTIONAL: Check if model file exists ===
if [ ! -f "models/$MODEL_NAME/$MODEL_FILE" ]; then
    echo "[!] Model file models/$MODEL_NAME/$MODEL_FILE not found."
    echo ">>> Please download and place your .gguf model file in the correct path."
    echo ">>> Example: models/$MODEL_NAME/$MODEL_FILE"
    exit 1
fi

# === OPTIONAL: Add Extensions ===
read -p "Do you want to install optional extensions (OpenAI API, SuperBooga)? (y/n): " EXT
if [[ "$EXT" == "y" || "$EXT" == "Y" ]]; then
    echo "[*] Installing extensions..."
    mkdir -p extensions
    git clone https://github.com/oobabooga/openai-api.git extensions/openai
    git clone https://github.com/yaroslav-ai/superbooga.git extensions/superbooga
fi

# === Start the Server ===
echo "[*] Starting WebUI with your model..."
python3 server.py --model "$MODEL_NAME" --model-file "$MODEL_FILE"
