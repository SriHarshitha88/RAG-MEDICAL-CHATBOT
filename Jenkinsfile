pipeline {
    agent any

    environment {
        ECR_REGION = 'eu-north-1'
        APPRUNNER_REGION = 'us-east-1'
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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-token']]) {
                    script {
                        def accountId = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                        def ecrUrl = "${accountId}.dkr.ecr.${env.ECR_REGION}.amazonaws.com/${env.ECR_REPO}"
                        def imageFullTag = "${ecrUrl}:${IMAGE_TAG}"

                        sh """
                        aws ecr get-login-password --region ${ECR_REGION} | docker login --username AWS --password-stdin ${ecrUrl}
                        docker build -t ${env.ECR_REPO}:${IMAGE_TAG} .
                        trivy image --severity HIGH,CRITICAL --format json -o trivy-report.json ${env.ECR_REPO}:${IMAGE_TAG} || true
                        docker tag ${env.ECR_REPO}:${IMAGE_TAG} ${imageFullTag}
                        docker push ${imageFullTag}
                        """

                        archiveArtifacts artifacts: 'trivy-report.json', allowEmptyArchive: true
                    }
                }
            }
        }

         stage('Deploy to AWS App Runner') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-token']]) {
                    script {
                        def accountId = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                        def ecrUrl = "${accountId}.dkr.ecr.${env.ECR_REGION}.amazonaws.com/${env.ECR_REPO}"
                        def imageFullTag = "${ecrUrl}:${IMAGE_TAG}"

                        echo "Triggering deployment to AWS App Runner in ${env.APPRUNNER_REGION}..."
                        echo "Using ECR image from ${env.ECR_REGION}: ${imageFullTag}"

                        sh """
                        SERVICE_ARN=\$(aws apprunner list-services --query "ServiceSummaryList[?ServiceName=='${SERVICE_NAME}'].ServiceArn" --output text --region ${env.APPRUNNER_REGION})

                        if [ -z "\$SERVICE_ARN" ] || [ "\$SERVICE_ARN" = "None" ]; then
                            echo "Service ${SERVICE_NAME} not found. Creating new App Runner service..."
                            aws apprunner create-service \
                                --service-name ${SERVICE_NAME} \
                                --source-configuration '{
                                    "ImageRepository": {
                                        "ImageIdentifier": "${imageFullTag}",
                                        "ImageRepositoryType": "ECR",
                                        "ImageConfiguration": {
                                            "Port": "5000"
                                        }
                                    },
                                    "AutoDeploymentsEnabled": false
                                }' \
                                --instance-configuration '{
                                    "Cpu": "1 vCPU",
                                    "Memory": "2 GB"
                                }' \
                                --region ${env.APPRUNNER_REGION}
                            echo "App Runner service created successfully"
                        else
                            echo "Found App Runner Service ARN: \$SERVICE_ARN"
                            echo "Updating existing service..."
                            aws apprunner update-service \
                                --service-arn \$SERVICE_ARN \
                                --source-configuration '{
                                    "ImageRepository": {
                                        "ImageIdentifier": "${imageFullTag}",
                                        "ImageRepositoryType": "ECR"
                                    },
                                    "AutoDeploymentsEnabled": false
                                }' \
                                --region ${env.APPRUNNER_REGION}
                            echo "Service updated successfully"
                        fi
                        """
                    }
                }
            }
        }
    }
}