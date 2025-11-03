pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = 'my-repo'
        IMAGE_TAG = 'latest'
        SERVICE_NAME = 'llmops-medical-service'
    }

    stages {
        stage('Clone GitHub Repo') {
            steps {
                script {
                    echo 'Cloning GitHub repo to Jenkins...'
                  checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/SriHarshitha88/RAG-MEDICAL-CHATBOT.git']])
                }
            }
        }

        stage('Build, Scan, and Push Docker Image to ECR') {
            steps {
                // Commented out AWS credentials for testing
                // withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-token']]) {
                    script {
                        echo "Building Docker image locally..."
                        sh """
                        # Check Jenkins environment
                        echo "=== Jenkins Environment Info ==="
                        echo "Current user: $(whoami)"
                        echo "User groups: $(groups)"
                        echo "Docker socket exists: $([ -e /var/run/docker.sock ] && echo 'YES' || echo 'NO')"
                        echo "Docker socket permissions: $([ -e /var/run/docker.sock ] && ls -l /var/run/docker.sock || echo 'N/A')"
                        echo "Docker command available: $(which docker || echo 'NOT FOUND')"
                        echo "Running in Docker container: $([ -f /.dockerenv ] && echo 'YES' || echo 'NO')"
                        echo ""

                        # Check if Docker is accessible
                        if ! docker info >/dev/null 2>&1; then
                            echo "ERROR: Docker is not accessible."
                            echo ""
                            echo "Possible solutions:"
                            echo "1. If Jenkins is in Docker: Restart with -v /var/run/docker.sock:/var/run/docker.sock"
                            echo "2. If Jenkins is on host: Run 'sudo usermod -aG docker jenkins' and restart Jenkins"
                            exit 1
                        fi
                        docker build -t ${env.ECR_REPO}:${IMAGE_TAG} .
                        trivy image --severity HIGH,CRITICAL --format json -o trivy-report.json ${env.ECR_REPO}:${IMAGE_TAG} || true
                        """

                        // AWS ECR push commented out for testing
                        // def accountId = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                        // def ecrUrl = "${accountId}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPO}"
                        // def imageFullTag = "${ecrUrl}:${IMAGE_TAG}"
                        // sh """
                        // aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ecrUrl}
                        // docker tag ${env.ECR_REPO}:${IMAGE_TAG} ${imageFullTag}
                        // docker push ${imageFullTag}
                        // """

                        archiveArtifacts artifacts: 'trivy-report.json', allowEmptyArchive: true
                    }
                // }
            }
        }

         stage('Deploy to AWS App Runner') {
            steps {
                echo "AWS App Runner deployment stage skipped for testing"
                // Commented out AWS credentials for testing
                // withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-token']]) {
                    script {
                        echo "AWS App Runner deployment would be triggered here..."

                        // AWS deployment code commented out for testing
                        // def accountId = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                        // def ecrUrl = "${accountId}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPO}"
                        // def imageFullTag = "${ecrUrl}:${IMAGE_TAG}"

                        // echo "Triggering deployment to AWS App Runner..."

                        // sh """
                        // SERVICE_ARN=\$(aws apprunner list-services --query "ServiceSummaryList[?ServiceName=='${SERVICE_NAME}'].ServiceArn" --output text --region ${AWS_REGION})
                        // echo "Found App Runner Service ARN: \$SERVICE_ARN"

                        // aws apprunner start-deployment --service-arn \$SERVICE_ARN --region ${AWS_REGION}
                        // """
                    }
                // }
            }
        }
    }
}