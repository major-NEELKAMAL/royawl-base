FROM eclipse-temurin:21-jdk-noble

LABEL com.aryanlab.protected="true"

# Install native dependencies required for OpenCV, JNI, and FFmpeg
RUN apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    python3-opencv \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
