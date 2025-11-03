@echo off
docker run -d ^
  --name jenkins-dind ^
  --privileged ^
  -p 8080:8080 ^
  -p 50000:50000 ^
  -v //var/run/docker.sock:/var/run/docker.sock ^
  -v jenkins_home:/var/jenkins_home ^
  jenkins-dind

echo.
echo Container started. Checking status...
docker ps -a | findstr jenkins-dind

echo.
echo To see logs, run: docker logs -f jenkins-dind
echo.
echo To access Jenkins, open http://localhost:8080 in your browser
echo To get initial password, run: docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword