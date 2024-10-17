# Use the official Node.js image
FROM node:18-slim

# Install dependencies for Puppeteer and other required packages
RUN apt-get update && apt-get install -y \
    chromium \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libxrandr2 \
    libasound2 \
    libatk1.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libxshmfence-dev \
    libglu1-mesa \
    libdrm-dev \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    xdg-utils \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable for Puppeteer to use the installed Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the application source code
COPY . .

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
