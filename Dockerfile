FROM node:18-slim

# Install only essential packages in one layer
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the environment variable for Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app

COPY package*.json ./

# Install npm dependencies
RUN npm install --production

COPY . .

# Expose the desired port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
