FROM eclipse-temurin:21-jdk-noble

RUN apt-get update && apt-get install -y \
    libopencv-dev \
    python3-opencv \
    mysql-client \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*
