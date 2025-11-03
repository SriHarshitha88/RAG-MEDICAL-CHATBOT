#!/bin/bash

# Script to set up Docker CLI in Jenkins container

# Check if Docker CLI is installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker CLI..."

    # Install prerequisites
    apt-get update
    apt-get install -y ca-certificates curl gnupg lsb-release

    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up the repository
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian trixie stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    apt-get update
    apt-get install -y docker-ce-cli docker-buildx-plugin docker-compose-plugin

    echo "Docker CLI installed successfully"
fi

# Create docker group if it doesn't exist
if ! getent group docker > /dev/null; then
    echo "Creating docker group..."
    groupadd -g 999 docker
fi

# Add jenkins user to docker group
if ! id jenkins | grep -q docker; then
    echo "Adding jenkins user to docker group..."
    usermod -aG docker jenkins
fi

# Set proper permissions on docker socket
if [ -e /var/run/docker.sock ]; then
    chown root:docker /var/run/docker.sock
    chmod 660 /var/run/docker.sock
fi

echo "Docker setup complete!"