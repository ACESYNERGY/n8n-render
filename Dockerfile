FROM node:18-bullseye

# Set working directory
WORKDIR /app

# Install system + TDLib build dependencies
RUN apt-get update && \
    apt-get install -y \
    wget unzip cmake g++ git libssl-dev zlib1g-dev \
    python3 python3-pip gperf pkg-config && \
    git clone --depth 1 --branch master https://github.com/tdlib/td.git /opt/tdlib && \
    mkdir /opt/tdlib/build && \
    cd /opt/tdlib/build && \
    cmake .. && \
    cmake --build . --target install && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set library path
ENV LD_LIBRARY_PATH=/usr/local/lib

# Install n8n and Telepilot
RUN npm install --location=global n8n && \
    n8n install n8n-nodes-telepilot

WORKDIR /home/node
EXPOSE 5678
CMD ["n8n"]
