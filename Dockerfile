FROM eclipse-temurin:21-jdk-noble

LABEL com.aryanlab.protected="true"

RUN apt-get update && apt-get install -y \
    libopencv-dev \
    libopencv-java \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*
