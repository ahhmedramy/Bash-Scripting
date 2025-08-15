#!/bin/bash

# Base directory
BASE_DIR=~/dev_envs
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

echo "[*] Creating environments..."

# HTML
mkdir -p html_env
echo "<!DOCTYPE html><html><head><title>HTML Env</title></head><body><h1>Hello HTML</h1></body></html>" > html_env/index.html

# CSS
mkdir -p css_env
echo "body { background-color: #f0f0f0; }" > css_env/style.css

# JavaScript
mkdir -p js_env
echo "console.log('Hello from JS');" > js_env/app.js

# HTML + CSS + JS combined
mkdir -p web_env
cat > web_env/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>Web Env</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Hello Web</h1>
  <script src="app.js"></script>
</body>
</html>
EOF
cp css_env/style.css web_env/
cp js_env/app.js web_env/

# C++ environment
mkdir -p cpp_env
echo '#include <iostream>\nint main() { std::cout << "Hello C++" << std::endl; return 0; }' > cpp_env/main.cpp

echo "[+] Installing required tools..."

# Install web preview server and compiler
sudo apt update
sudo apt install -y g++ nodejs npm

# Install live-server if not present
if ! command -v live-server &> /dev/null; then
    sudo npm install -g live-server
fi

# Create launcher scripts
echo -e "#!/bin/bash\nlive-server $BASE_DIR/web_env" > run_web_env.sh
chmod +x run_web_env.sh

echo -e "#!/bin/bash\ncd $BASE_DIR/cpp_env && g++ main.cpp -o run && ./run" > run_cpp_env.sh
chmod +x run_cpp_env.sh

echo "[✔] Environments set up:"
echo "HTML: $BASE_DIR/html_env"
echo "CSS: $BASE_DIR/css_env"
echo "JS: $BASE_DIR/js_env"
echo "Web (HTML+CSS+JS): $BASE_DIR/web_env"
echo "C++: $BASE_DIR/cpp_env"
echo ""
echo "Run GUI server: ./run_web_env.sh"
echo "Run C++ app: ./run_cpp_env.sh"
