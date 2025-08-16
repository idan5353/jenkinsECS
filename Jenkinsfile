pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "851725642392.dkr.ecr.us-east-1.amazonaws.com/my-app"
        CLUSTER_NAME = "my-ecs-cluster"
        SERVICE_NAME = "my-app-service"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/idan5353/jenkinsECS.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | \
                        docker login --username AWS --password-stdin $ECR_REPO
                        docker build -t $ECR_REPO:latest -f app/Dockerfile app/
                        docker push $ECR_REPO:latest
                    """
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh """
                    aws ecs update-service \
                        --cluster $CLUSTER_NAME \
                        --service $SERVICE_NAME \
                        --force-new-deployment \
                        --region $AWS_REGION
                """
            }
        }
    }
}
