FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    openjdk-17-jdk \
    autoconf \
    libtool \
    pkg-config \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libtinfo5 \
    cmake \
    libffi-dev \
    libssl-dev \
    automake \
    help2man \
    wget \
    python3-tk \
    && rm -rf /var/lib/apt/lists/*

# Install buildozer and dependencies
RUN pip install --no-cache-dir buildozer cython "kivy>=2.2.0" requests

# Create working directory
WORKDIR /app

# Default command
CMD ["buildozer", "--help"]
