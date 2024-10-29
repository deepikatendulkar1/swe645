pipeline {
    agent any
    environment {
        registry = "sanjanavegesna/myapp"
        registryCredential = 'docker-pass'
        gcpProject = 'fabled-plating-440011-d6'
        gcpServiceAccount = 'jenkins1@fabled-plating-440011-d6.iam.gserviceaccount.com'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/deepikatendulkar1/swe645'
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
                    withCredentials([file(credentialsId: gcpServiceAccount, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud container clusters get-credentials k8s-cluster-1 --zone us-east1-b
                        kubectl apply -f deployment.yaml
                        '''
                    }
                }
            }
        }
    }
}
