FROM node:10-buster

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    libssl-dev \
    libboost-all-dev \
    libsodium-dev \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# To edit package.json so dependency issues don't arise
RUN sed -i 's|git://github.com|git+https://github.com|' package.json \
    && sed -i 's|"bignum": *".*"|"bignum": "0.13.0"|' package.json \
    && sed -i 's|"dateformat": *".*"|"dateformat": "3.0.3"|' package.json \
    && sed -i 's|"mailgun.js": *".*"|"mailgun.js": "2.0.1"|' package.json \
    && sed -i 's|"node-telegram-bot-api": *".*"|"node-telegram-bot-api": "^0.66.0"|' package.json \
    && sed -i 's|"redis": *".*"|"redis": "2.8.0"|' package.json \
    && sed -i 's|"request": *".*"|"request": "2.88.0"|' package.json \
    && sed -i 's|"request-promise-native": *".*"|"request-promise-native": "1.0.7"|' package.json

# Install npm dependencies
RUN npm install

# Uncomment and modify the following lines as necessary for your project
RUN cp config_examples/ryo.json config.json
RUN sed -i 's|"poolAddress": *".*"|"poolAddress": "${POOL_ADDRESS}"|' config.json
RUN apt-get update && apt-get install -y jq
RUN jq '.daemon.port = 12211' config.json > config.tmp && mv config.tmp config.json

RUN redis-server --daemonize yes
RUN node init.js

