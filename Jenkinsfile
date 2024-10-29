pipeline {
    agent any
    environment {
        registry = "sanjanavegesna/newapp"               // Docker image repository name
        registryCredential = 'docker-pass'               // Docker Hub credentials ID in Jenkins
        gcpProject = 'superb-shelter-440100-q7'          // GCP project ID
        gcpServiceAccount = 'gcpServiceAccount'          // GCP service account credential ID in Jenkins
        clusterName = 'cluster-1'                        // GKE cluster name
        clusterZone = 'us-central1-c'                    // GKE cluster zone
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
                        # Authenticate with GCP and set the project
                        export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud config set project ${gcpProject}
                        
                        # Get GKE cluster credentials
                        gcloud container clusters get-credentials ${clusterName} --zone ${clusterZone} --project ${gcpProject}
                        
                        # Apply Kubernetes configurations
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up the Docker image from Jenkins to save space
                dockerImage.remove()
            }
        }
    }
}
