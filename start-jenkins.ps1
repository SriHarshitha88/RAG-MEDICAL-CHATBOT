# Check Docker is running
Write-Host "Checking Docker status..."
docker version

# Create a volume for Jenkins data if it doesn't exist
docker volume create jenkins_home

# Run Jenkins container with Docker access
Write-Host "Starting Jenkins container..."
docker run -d --name jenkins-dind `
    -v "/var/run/docker.sock:/var/run/docker.sock" `
    -v "jenkins_home:/var/jenkins_home" `
    -p 8080:8080 `
    -p 50000:50000 `
    --privileged `
    jenkins/jenkins:lts

# Wait a moment for Jenkins to start
Start-Sleep -Seconds 5

# Check if container is running
Write-Host "Checking container status..."
docker ps

# Get initial admin password
Write-Host "Getting Jenkins initial password..."
docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword

Write-Host "`nJenkins is starting up!"
Write-Host "Access Jenkins at: http://localhost:8080"
Write-Host "Use the password above to unlock Jenkins"