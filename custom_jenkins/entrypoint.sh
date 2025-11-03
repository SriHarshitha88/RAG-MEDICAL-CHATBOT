#!/bin/bash

# Ensure Docker socket has correct permissions on startup
if [ -e /var/run/docker.sock ]; then
    # Create docker group if it doesn't exist
    if ! getent group docker > /dev/null; then
        groupadd -g 999 docker
    fi

    # Add jenkins to docker group
    usermod -aG docker jenkins

    # Set correct permissions on docker socket
    chown root:docker /var/run/docker.sock
    chmod 660 /var/run/docker.sock
fi

# Start Jenkins
exec /usr/local/bin/jenkins.sh