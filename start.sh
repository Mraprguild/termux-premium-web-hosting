#!/data/data/com.termux/files/usr/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PUBLIC_DIR="$PROJECT_DIR/public"
PID_FILE="$PROJECT_DIR/.server.pid"
LOG_FILE="$PROJECT_DIR/server.log"
PORT="${PORT:-8080}"
HOST="${HOST:-127.0.0.1}"
MODE="${1:-foreground}"

if ! command -v python >/dev/null 2>&1; then
    echo "Python is not installed. Run ./install.sh first."
    exit 1
fi

if [ ! -d "$PUBLIC_DIR" ]; then
    echo "Website folder not found: $PUBLIC_DIR"
    exit 1
fi

if [ -f "$PID_FILE" ]; then
    OLD_PID="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Server is already running."
        echo "PID: $OLD_PID"
        echo "URL: http://$HOST:$PORT"
        exit 0
    fi
    rm -f "$PID_FILE"
fi

cd "$PUBLIC_DIR"

echo
echo "========================================"
echo " Mraprguild Premium Web Hosting"
echo "========================================"
echo " URL  : http://$HOST:$PORT"
echo " Root : $PUBLIC_DIR"
echo "========================================"
echo

if [ "$MODE" = "--background" ] || [ "$MODE" = "-b" ]; then
    nohup python -m http.server "$PORT" --bind "$HOST" >"$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    echo "$SERVER_PID" > "$PID_FILE"
    sleep 1

    if kill -0 "$SERVER_PID" 2>/dev/null; then
        echo "Server started in background."
        echo "PID: $SERVER_PID"
        echo "Log: $LOG_FILE"
        echo "Stop: ./stop.sh"
    else
        echo "Server failed to start."
        rm -f "$PID_FILE"
        exit 1
    fi
else
    echo "Press CTRL+C to stop the server."
    python -m http.server "$PORT" --bind "$HOST"
fi
