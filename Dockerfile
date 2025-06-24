FROM n8nio/n8n:latest

# Install required native dependencies for Telepilot
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

# Force re-install Telepilot community node inside container
RUN n8n install n8n-nodes-telepilot

# Rebuild native bindings
RUN cd /home/node/.n8n/nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt && npm install

# Set working directory
WORKDIR /home/node

CMD ["n8n"]
