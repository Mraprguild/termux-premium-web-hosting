#!/data/data/com.termux/files/usr/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$PROJECT_DIR/.server.pid"
PORT="${PORT:-8080}"
HOST="${HOST:-127.0.0.1}"

if [ -f "$PID_FILE" ]; then
    PID="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        echo "Status: running"
        echo "PID: $PID"
        echo "URL: http://$HOST:$PORT"
        exit 0
    fi
fi

echo "Status: stopped"
exit 1
