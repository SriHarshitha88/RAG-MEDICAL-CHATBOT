#!/bin/bash

# Stop and remove existing Jenkins container
docker stop jenkins-dind 2>/dev/null
docker rm jenkins-dind 2>/dev/null

# Run Jenkins with Docker access (using Git Bash path format)
winpty docker run -d --name jenkins-dind \
    -v "/${PWD}/:/var/jenkins_home" \
    -p 8080:8080 \
    -p 50000:50000 \
    --privileged \
    jenkins/jenkins:lts

echo "Jenkins started!"
echo "Access at: http://localhost:8080"