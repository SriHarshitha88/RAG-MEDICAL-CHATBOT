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
                        sudo docker build -t ${env.ECR_REPO}:${IMAGE_TAG} .
                        sudo trivy image --severity HIGH,CRITICAL --format json -o trivy-report.json ${env.ECR_REPO}:${IMAGE_TAG} || true
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