#!/bin/bash

echo "🛑 Stopping all Persona Market services..."
echo ""

pkill -f "gradlew bootRun"
pkill -f "flutter run"
docker-compose down

echo "✅ All services stopped!"
