# Stage 1: Build stage
FROM node:20.11.1-slim AS build

# Install dependencies and global npm packages
RUN apt-get update && \
    apt-get install -y git curl procps && \
    git config --global --add safe.directory /site && \
    npm install -g gatsby-cli typescript vercel netlify-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Update npm to the latest version
RUN npm install -g npm@latest

# Stage 2: Final stage
FROM node:20.11.1-slim

# Install dependencies and copy global npm packages from the build stage
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git curl procps && \
    npm install -g npm@latest && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy global npm packages and libraries from the build stage
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/lib /usr/local/lib

WORKDIR /site

# Copy setup script
COPY setup.sh /usr/bin
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
