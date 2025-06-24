FROM node:18-bullseye

# Set working directory
WORKDIR /app

# Install system dependencies (includes TDLib build tools)
RUN apt-get update && \
    apt-get install -y wget unzip cmake g++ git libssl-dev zlib1g-dev && \
    git clone --depth 1 --branch master https://github.com/tdlib/td.git /opt/tdlib && \
    mkdir /opt/tdlib/build && \
    cd /opt/tdlib/build && \
    cmake .. && \
    cmake --build . --target install && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set library path
ENV LD_LIBRARY_PATH=/usr/local/lib

# Install n8n and Telepilot node
RUN npm install --location=global n8n \
    && n8n install n8n-nodes-telepilot

# Create n8n folder
RUN mkdir -p /home/node/.n8n
WORKDIR /home/node

# Expose default n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
