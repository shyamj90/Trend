pipeline{
    agent any
    environment{
        DOCKERHUB_CREDS=credentials("dockerhub")
        IMAGE_NAME="shyamj90/trend"
    }
    stages{
        stage("Clone Repo"){
            steps{
                git branch: "main" , url : "https://github.com/shyamj90/Trend"
            }
        }
        stage("Build Image"){
            steps{
                script{
                    sh "docker build -t $IMAGE_NAME:latest ."
                }
            }
        }
        stage("Login to Dockerhub"){
            steps{
                script{
                    sh "echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin"
                }
            }
        }
        stage("Push Image to Dockerhub"){
            steps{
                script{
                    sh "docker push $IMAGE_NAME:latest"
                }
            }

        }
        stage("Deploy to EKS"){
            steps{
                script{
                    sh """
                        aws eks update-kubeconfig --region us-east-2 --name ssj-eks1
                        kubectl apply -f deployment.yaml
                    """
                }
            }
        }
    }
}