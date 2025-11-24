#!/bin/bash

echo "🐳 Starting Docker PostgreSQL..."
echo ""

cd /Users/mac/Desktop/Project/persona-market

docker-compose up -d

echo ""
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

until docker exec persona-market-db pg_isready -U postgres > /dev/null 2>&1; do
    echo "Waiting for database connection..."
    sleep 2
done

echo ""
echo "✅ PostgreSQL is ready!"
echo ""
echo "🌐 Access points:"
echo "   PostgreSQL: localhost:5432"
echo "   Adminer (DB UI): http://localhost:8082"
echo ""
echo "📋 Database Info:"
echo "   Database: persona_market"
echo "   Username: postgres"
echo "   Password: postgres"
echo ""
echo "🔧 Useful commands:"
echo "   docker-compose logs -f      # View logs"
echo "   docker-compose down         # Stop containers"
echo "   docker-compose down -v      # Stop and remove data"
echo "   docker exec -it persona-market-db psql -U postgres -d persona_market  # Connect to DB"
echo ""
