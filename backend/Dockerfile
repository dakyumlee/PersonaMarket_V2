FROM gradle:8.5-jdk17-alpine AS build
WORKDIR /app
COPY . .
RUN gradle clean build -x test --no-daemon

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Python 설치
RUN apk add --no-cache python3 py3-pip tzdata && \
    ln -sf python3 /usr/bin/python

# Python 패키지 설치
RUN pip3 install --no-cache-dir openai requests

ENV TZ=Asia/Seoul
COPY --from=build /app/build/libs/*.jar app.jar
COPY src/main/resources/python /app/python

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

EXPOSE 8080
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
