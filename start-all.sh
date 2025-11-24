#!/bin/bash

echo "🚀 Starting Persona Market in separate terminals..."
echo ""

PROJECT_DIR="/Users/mac/Desktop/Project/persona-market"
cd "$PROJECT_DIR"

mkdir -p logs

echo "📊 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker first."
    exit 1
fi

if ! command -v java &> /dev/null; then
    echo "❌ Java not found. Please install Java 17+ first."
    exit 1
fi

if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

echo "✅ All prerequisites satisfied"
echo ""

if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    exit 1
fi

echo "🐳 Starting Docker PostgreSQL in Terminal 1..."
osascript -e "tell application \"Terminal\"
    do script \"cd '$PROJECT_DIR' && echo '🐳 Starting Docker PostgreSQL...' && docker-compose up\"
end tell"

sleep 3

echo "⏳ Waiting for PostgreSQL to be ready..."
until docker exec persona-market-db pg_isready -U postgres > /dev/null 2>&1; do
    echo "Waiting for database connection..."
    sleep 2
done

echo "✅ Database ready"
echo ""

echo "📋 Applying database schema..."
docker exec -i persona-market-db psql -U postgres -d persona_market < database/schema.sql 2>/dev/null
echo "✅ Schema applied"
echo ""

sleep 2

echo "🔧 Starting Backend in Terminal 2..."
osascript -e "tell application \"Terminal\"
    do script \"cd '$PROJECT_DIR/backend' && echo '🔧 Starting Spring Boot Backend...' && ./run.sh\"
end tell"

sleep 5

echo "🎨 Starting Frontend in Terminal 3..."
osascript -e "tell application \"Terminal\"
    do script \"cd '$PROJECT_DIR/frontend' && echo '🎨 Starting Flutter Frontend...' && flutter pub get && flutter run -d chrome --web-port 8081\"
end tell"

sleep 2

echo "📊 Opening Logs in Terminal 4..."
osascript -e "tell application \"Terminal\"
    do script \"cd '$PROJECT_DIR' && echo '📊 Watching Logs...' && echo '' && echo 'Backend logs:' && echo '---' && tail -f backend/build/resources/main/application.yml 2>/dev/null || echo 'Waiting for backend...'\"
end tell"

echo ""
echo "✨ All services starting in separate terminals!"
echo ""
echo "🌐 Access points:"
echo "   Backend API:  http://localhost:8080"
echo "   Frontend:     http://localhost:8081"
echo "   DB Admin:     http://localhost:8082"
echo "   PostgreSQL:   localhost:5435"
echo ""
echo "💡 Tips:"
echo "   - Terminal 1: Docker logs"
echo "   - Terminal 2: Backend logs"
echo "   - Terminal 3: Frontend logs"
echo "   - Terminal 4: Combined logs"
echo ""
echo "🛑 To stop all services:"
echo "   Ctrl+C in each terminal or run: ./stop-all.sh"
echo ""
