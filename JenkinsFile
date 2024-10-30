pipeline {
    agent any
    environment {
        registry = "sanjanavegesna/newapp"
        registryCredential = 'docker-pass'
        gcpProject = 'cool-adviser-440223-d1'
        gcpServiceAccount= 'gcpServiceAccount'
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
           
                        withCredentials([file(credentialsId: gcpServiceAccount, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh '''
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud container clusters get-credentials cluster-1 --zone us-central1-c
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                        kubectl delete pod -l app=newapp
                        
                        '''
            }
        }
    }
}

                }
            }
