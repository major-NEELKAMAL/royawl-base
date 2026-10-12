FROM eclipse-temurin:21-jdk

LABEL com.aryanlab.protected="true"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    libopencv-java \
    ffmpeg \
    mysql-client \
    && rm -rf /var/lib/apt/lists/* \
    && mysqldump --version
