# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set non-interactive installation mode and desired locale
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install necessary packages and clean up in one step
RUN apt-get update && apt-get install -y \
    locales \
    tclsh \
    pkg-config \
    cmake \
    libssl-dev \
    build-essential \
    git \
    curl \
    g++ \
    gzip \
    tar \
    bzip2 \
    python3 \
    libedit-dev \
    libusb-1.0-0-dev \
    ffmpeg \
    libsrt-openssl-dev \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone, build and install the SRT library
WORKDIR /srt
RUN git clone https://github.com/Haivision/srt.git . \
    && ./configure \
    && make \
    && make install \
    && rm -rf /srt

# Install additional prerequisites and build TSDuck
WORKDIR /tsduck
RUN git clone https://github.com/tsduck/tsduck.git . \
    && scripts/install-prerequisites.sh \
    && make -j$(nproc) NOPCSC=0 NOCURL=0 NODTAPI=0 \
    && make install \
    && ldconfig \
    && rm -rf /tsduck

# Copy all files from the video.mp4 directory into the image
COPY ./video.mp4/ /videos/

COPY entrypoint.sh /entrypoint.sh
COPY logo.png /logo.png

# Make the shell script executable
RUN chmod +x /entrypoint.sh

# Define entry point to handle the streaming
ENTRYPOINT ["/entrypoint.sh"]
