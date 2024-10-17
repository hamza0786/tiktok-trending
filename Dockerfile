FROM node:18

# Install Chromium
RUN apt-get update && apt-get install -y \
    chromium \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Puppeteer
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV CHROME_BIN=/usr/bin/chromium

# Copy your application files
COPY . .

# Install dependencies
RUN npm install

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
