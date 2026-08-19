FROM eclipse-temurin:21-jdk

LABEL com.aryanlab.protected="true"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    libopencv-java \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*
