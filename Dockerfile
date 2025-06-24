FROM n8nio/n8n:1.45.0-debian

# Install TDLib build dependencies
RUN apt-get update && \
    apt-get install -y wget unzip cmake g++ git libssl-dev zlib1g-dev && \
    git clone --depth 1 --branch master https://github.com/tdlib/td.git /opt/tdlib && \
    mkdir /opt/tdlib/build && \
    cd /opt/tdlib/build && \
    cmake .. && \
    cmake --build . --target install && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set library path so Telepilot can find libtdjson.so
ENV LD_LIBRARY_PATH=/usr/local/lib

# Pre-install Telepilot node globally so it’s baked into container
RUN n8n install n8n-nodes-telepilot

# Working directory for n8n
WORKDIR /home/node

# Default startup
CMD ["n8n"]
