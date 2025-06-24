FROM node:18-bullseye

WORKDIR /app

# Install n8n globally
RUN npm install --location=global n8n

WORKDIR /home/node
EXPOSE 5678
CMD ["n8n"]
