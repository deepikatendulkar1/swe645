pipeline {
    agent any
    environment {
        registry = "sanjanavegesna/myapp"
        registryCredential = 'docker-pass'
        gcpProject = 'fabled-plating-440011-d6'
        gcpServiceAccount = 'gcpServiceAccount'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/deepikatendulkar1/swe645'
            }
        }
        stage('Check Docker Version') {
            steps {
                script {
                    sh 'docker --version'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${registry}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', registryCredential) {
                        dockerImage.push("latest")
                        dockerImage.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
stage('Deploy to GKE') {
    steps {
        script {
            withCredentials([file(credentialsId: 'your-credentials-id', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                sh '''
                export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
                gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                gcloud config set project YOUR_PROJECT_ID  # Add this line
                gcloud container clusters get-credentials k8s-cluster-1 --zone us-east1-b
                '''
            }
        }
    }
}

                }
            }
        
    }
}
