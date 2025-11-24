#!/bin/bash

# .env 파일에서 환경변수 로드
if [ -f "../.env" ]; then
    export $(cat ../.env | grep -v '^#' | xargs)
    echo "✅ Environment variables loaded from .env"
else
    echo "⚠️  .env file not found!"
    exit 1
fi

# Gradle bootRun
./gradlew bootRun
