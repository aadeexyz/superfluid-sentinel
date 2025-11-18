FROM node:lts

# Set environment variables
ENV NODE_ENV=production

# Create app directory
WORKDIR /app

# Install dependencies
RUN apt update && apt install -y \
    git \
    python3 \
    make \
    g++ \
    ca-certificates \
    tini 

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install app dependencies
RUN yarn install --production

# Copy the rest of the application
COPY . ./

# make sure we can write the data directory
RUN chown -R node:node /app/data \
    && chmod -R 755 /app/data

# Use tini as the entrypoint
ENTRYPOINT ["tini", "--"]

# Don't run as root
USER node

# Start the application
CMD ["node", "main.js"]
