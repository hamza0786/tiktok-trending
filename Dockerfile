# Use a Node.js image as the base
FROM node:18

# Install Chromium instead of Google Chrome
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    xdg-utils \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN which chromium
    
# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy the rest of the application code
COPY . .

# Set environment variable to use system Chrome
# Set environment variable to use Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROMIUM_PATH=/usr/bin/chromium

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
