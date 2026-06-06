#!/data/data/com.termux/files/usr/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$PROJECT_DIR/.server.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "No background server PID file was found."
    exit 0
fi

PID="$(cat "$PID_FILE" 2>/dev/null || true)"

if [ -z "$PID" ]; then
    rm -f "$PID_FILE"
    echo "Invalid PID file removed."
    exit 0
fi

if kill -0 "$PID" 2>/dev/null; then
    kill "$PID"
    sleep 1

    if kill -0 "$PID" 2>/dev/null; then
        kill -9 "$PID" 2>/dev/null || true
    fi

    echo "Server stopped."
else
    echo "Server was not running."
fi

rm -f "$PID_FILE"
