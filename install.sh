#!/data/data/com.termux/files/usr/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo
echo "========================================"
echo " Termux Premium Web Hosting Installer"
echo "========================================"
echo

pkg update -y
pkg install python git -y

chmod +x "$PROJECT_DIR/start.sh"
chmod +x "$PROJECT_DIR/stop.sh"
chmod +x "$PROJECT_DIR/status.sh"

if [ ! -d "$PROJECT_DIR/public" ]; then
    echo "Error: public directory is missing."
    exit 1
fi

echo
echo "Installation completed successfully."
echo
echo "Start website:"
echo "  ./start.sh"
echo
echo "Background mode:"
echo "  ./start.sh --background"
echo
