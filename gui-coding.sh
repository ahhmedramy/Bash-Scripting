#!/bin/bash
# Dev Environment Setup Script with GUI Launch and Language Separation

# Define root working directory
ROOT_DIR="$HOME/dev-envs"
mkdir -p "$ROOT_DIR"

# Define language environments
ENVIRONMENTS=(
  "html"
  "css"
  "javascript"
  "cpp"
  "html_css"
  "html_js"
  "html_css_js"
)

# Create folders for each environment
for env in "${ENVIRONMENTS[@]}"; do
  mkdir -p "$ROOT_DIR/$env"
  touch "$ROOT_DIR/$env/README.md"
  echo "# $env environment" > "$ROOT_DIR/$env/README.md"
  echo "Created environment: $env"
done

# Setup Python HTTP server in all web-related envs
for env in html html_css html_js html_css_js; do
  echo "<!DOCTYPE html><html><head><title>$env</title></head><body><h1>Welcome to $env</h1></body></html>" > "$ROOT_DIR/$env/index.html"
  echo "Starting server in $env on port 8000"
done

# Generate GUI launcher script
cat << 'EOF' > "$ROOT_DIR/launch_gui.sh"
#!/bin/bash
zenity --list \
  --title="Select Environment to Launch" \
  --column="Environments" \
  html css javascript cpp html_css html_js html_css_js \
  --height=400 --width=300 > /tmp/selected_env

ENV=$(cat /tmp/selected_env)

case $ENV in
  html|html_css|html_js|html_css_js)
    cd "$HOME/dev-envs/$ENV"
    python3 -m http.server 8000
    ;;
  cpp)
    cd "$HOME/dev-envs/cpp"
    zenity --info --text="Use any C++ IDE or editor to compile files in this directory."
    ;;
  css|javascript)
    cd "$HOME/dev-envs/$ENV"
    zenity --info --text="Open your files in your preferred editor."
    ;;
  *)
    zenity --error --text="Invalid selection."
    ;;
esac
EOF

chmod +x "$ROOT_DIR/launch_gui.sh"
echo "Launcher created: $ROOT_DIR/launch_gui.sh"
echo "Run it with: bash $ROOT_DIR/launch_gui.sh"
