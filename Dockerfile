# Use an official Node.js runtime as a parent image
FROM node:18-slim

# Install necessary packages for Chromium
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Chromium
RUN apt-get update && \
    echo "deb http://deb.debian.org/debian stable main" >> /etc/apt/sources.list && \
    wget -qO - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt-get update && \
    apt-get install -y chromium && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for Puppeteer
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV CHROME_BIN=/usr/bin/chromium

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of your application code
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
