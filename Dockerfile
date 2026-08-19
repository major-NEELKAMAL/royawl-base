FROM eclipse-temurin:21-jdk-noble

LABEL com.aryanlab.protected="true"

RUN apt-get update && apt-get install -y \
    libopencv-dev \
    python3-opencv \
    mysql-client \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*
