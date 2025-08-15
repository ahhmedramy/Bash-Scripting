#!/bin/bash

echo "[+] Creating folders..."
mkdir -p ~/dev-envs/{html,css,html-css,javascript,html-js,cpp}

echo "[+] Setting up HTML..."
echo "<!DOCTYPE html><html><head><title>HTML Page</title></head><body><h1>Hello HTML</h1></body></html>" > ~/dev-envs/html/index.html

echo "[+] Setting up CSS..."
echo "body { background-color: lightblue; }" > ~/dev-envs/css/style.css

echo "[+] Setting up HTML+CSS..."
cat <<EOF > ~/dev-envs/html-css/index.html
<!DOCTYPE html>
<html>
<head>
<title>HTML + CSS</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
<h1>Styled Page</h1>
</body>
</html>
EOF

echo "[+] Setting up JavaScript..."
echo "console.log('Hello JavaScript');" > ~/dev-envs/javascript/index.js

echo "[+] Setting up HTML+JavaScript..."
cat <<EOF > ~/dev-envs/html-js/index.html
<!DOCTYPE html>
<html>
<head><title>HTML + JS</title></head>
<body>
<h1>Check Console</h1>
<script src="../javascript/index.js"></script>
</body>
</html>
EOF

echo "[+] Setting up C++..."
echo '#include <iostream>
int main() {
    std::cout << "Hello C++" << std::endl;
    return 0;
}' > ~/dev-envs/cpp/main.cpp

echo "[+] Installing required packages..."

# HTML/CSS require no installs
sudo apt update
sudo apt install -y zenity g++ nodejs npm xdg-utils

echo "[+] Setup complete!"
