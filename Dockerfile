FROM node:10-buster

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    libssl-dev \
    libboost-all-dev \
    libsodium-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Install npm dependencies
RUN npm install

# Uncomment and modify the following lines as necessary for your project
RUN sed -i 's|"poolAddress": *".*"|"poolAddress": "RYoLshZp8BCCkCa3pon5i3HW1XK18UaieFwb8knfhdbYAEVC1VMxD7PVF97CdDarhjSFJmdVYEuwC4EqzKB6Ya99R8AeaYe8TAH"|' config.json

CMD ["node", "init.js"]



