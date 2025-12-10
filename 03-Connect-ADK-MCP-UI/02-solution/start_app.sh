#!/bin/bash

# Define the root directory of the solution
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to kill processes when script exits
cleanup() {
    echo ""
    echo "🛑 Stopping processes..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID
    fi
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID
    fi
    exit
}

# Trap SIGINT (Ctrl+C)
trap cleanup SIGINT


# Function to check and kill port
check_port() {
    PORT=$1
    echo "Checking port $PORT..."
    if command -v fuser &> /dev/null; then
        # Try using fuser (common on Linux/CloudShell)
        fuser -k -n tcp $PORT > /dev/null 2>&1
    elif command -v lsof &> /dev/null; then
        # Fallback to lsof (common on macOS)
        PID=$(lsof -ti :$PORT)
        if [ ! -z "$PID" ]; then
            echo "⚠️  Port $PORT is in use by PID $PID. Killing it..."
            kill -9 $PID
        fi
    else
        echo "⚠️  Warning: Neither 'fuser' nor 'lsof' found. Cannot check/kill port $PORT."
        echo "If you get an address in use error, please manually find and kill the process on port $PORT."
    fi
    sleep 1
}

echo "🔌 Checking Ports..."
check_port 8000
check_port 5173

echo "🔑 Checking Environment..."
# Check for .env file and copy from root if missing
if [ ! -f "$PROJECT_ROOT/backend/.env" ]; then
    if [ -f "$PROJECT_ROOT/../../.env" ]; then
        echo "📄 Found .env at root workspace, copying to backend..."
        cp "$PROJECT_ROOT/../../.env" "$PROJECT_ROOT/backend/.env"
    fi
fi

if [ -f "$PROJECT_ROOT/backend/.env" ]; then
    if ! grep -q "GOOGLE_API_KEY" "$PROJECT_ROOT/backend/.env"; then
        echo "⚠️  WARNING: GOOGLE_API_KEY not found in backend/.env. Agent may fail to initialize."
    fi
else
    echo "⚠️  WARNING: backend/.env file not found. Please create it with your GOOGLE_API_KEY."
fi

echo "📦 Checking Backend Dependencies..."
cd "$PROJECT_ROOT/backend"
if [ -f .env ]; then
    source .env
fi
uv sync

echo "🚀 Starting Backend..."
uv run python main.py &
BACKEND_PID=$!
echo "✅ Backend started with PID $BACKEND_PID"

echo "� Checking Frontend Dependencies..."
cd "$PROJECT_ROOT/frontend"
npm install

echo "🚀 Starting Frontend..."
npm run dev -- --host &
FRONTEND_PID=$!
echo "✅ Frontend started with PID $FRONTEND_PID"

echo "💡 App is running! Press Ctrl+C to stop both servers."

# Wait for processes
wait
