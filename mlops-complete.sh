#!/bin/bash

echo "Select the environment to set up:"
echo "1) Full DevOps Environment"
echo "2) AI & MLOps Stack"
echo "3) Local LLM Playground"
echo "4) Web Dev + Language Envs (HTML/CSS/JS/C++)"
read -p "Enter option number: " choice

case $choice in
1)
  echo "Setting up Full DevOps Environment..."
  sudo apt update && sudo apt install -y \
    terraform ansible docker.io docker-compose \
    kubectl helm minikube awscli azure-cli google-cloud-sdk \
    curl unzip jq zsh
  
  # Oh My Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "DevOps stack installed."
  ;;
2)
  echo "Setting up AI & MLOps Stack..."
  sudo apt install -y python3 python3-pip python3-venv
  python3 -m venv ml_env && source ml_env/bin/activate
  pip install --upgrade pip
  pip install jupyterlab mlflow dvc transformers datasets langchain openai fastapi uvicorn docker prefect
  echo "AI stack ready. To run: source ml_env/bin/activate"
  ;;
3)
  echo "Setting up Local LLM Playground..."
  sudo apt install -y git python3 python3-pip python3-venv
  git clone https://github.com/oobabooga/text-generation-webui ~/textgen
  cd ~/textgen
  python3 -m venv llm_env && source llm_env/bin/activate
  pip install -r requirements.txt
  echo "LLM Playground installed in ~/textgen"
  ;;
4)
  echo "Setting up Web Dev + Language Envs..."

  sudo apt install -y build-essential g++ python3 python3-pip python3-venv nodejs npm

  mkdir -p ~/dev_envs
  cd ~/dev_envs

  # HTML + CSS env
  mkdir html_css && echo "<!DOCTYPE html><html><head><title>Test</title><link rel='stylesheet' href='style.css'></head><body><h1>Hello</h1></body></html>" > html_css/index.html && echo "h1 {color: red;}" > html_css/style.css

  # JavaScript env
  mkdir js && echo "console.log('Hello from JS');" > js/app.js && echo "<!DOCTYPE html><html><body><script src='app.js'></script></body></html>" > js/index.html

  # C++ env
  mkdir cpp && echo '#include<iostream>\nint main(){ std::cout<<"Hello C++"<<std::endl; return 0; }' > cpp/main.cpp

  # Merged env
  mkdir webapp && cp -r html_css/* webapp/ && cp js/app.js webapp/

  echo "Web development environments created in ~/dev_envs"
  ;;
*)
  echo "Invalid option. Exiting."
  ;;
esac
