# Stop and remove existing Jenkins container
docker stop jenkins-dind
docker rm jenkins-dind

# Create Jenkins container with proper Docker access
docker run -d --name jenkins-dind `
    -v //var/run/docker.sock:/var/run/docker.sock `
    -v jenkins_home:/var/jenkins_home `
    -p 8080:8080 `
    -p 50000:50000 `
    --group-add $(Get-Content /etc/group | Where-Object { $_ -like "docker:*" } | ForEach-Object { ($_ -split ':')[2] }) `
    jenkins/jenkins:lts

Write-Host "Jenkins restarted with proper Docker permissions!"
Write-Host "Access Jenkins at: http://localhost:8080"