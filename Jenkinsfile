pipeline { 

    agent any 

  

    environment { 

        DOCKER_IMAGE = "sanjanavegesna/myapp" 

        K8S_NAMESPACE = "default"  // Update if needed 

        KUBECONFIG_CRED_ID = "kubeconfig-id"  // Kubernetes credential ID 

        DOCKER_CREDENTIALS_ID = "docker-pass"  // DockerHub credentials 

    } 

  

    stages { 

        stage('Clone Repository') { 

            steps { 

                git branch: 'main', url: 'https://github.com/deepikatendulkar1/swe645.git' 

            } 

        } 

  

        stage('Build Application') { 

            steps { 

                script { 

                    sh 'npm install'   // Replace with your build command 

                    sh 'npm run build' // Replace with your build command 

                } 

            } 

        } 

  

        stage('Build Docker Image') { 

            steps { 

                script { 

                    docker.build(DOCKER_IMAGE) 

                } 

            } 

        } 

  

        stage('Push Docker Image') { 

            steps { 

                script { 

                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) { 

                        docker.image(DOCKER_IMAGE).push('latest') 

                    } 

                } 

            } 

        } 

  

        stage('Deploy to Kubernetes') { 

            steps { 

                script { 

                    withKubeConfig([credentialsId: KUBECONFIG_CRED_ID]) { 

                        sh ''' 

                        kubectl set image deployment/your-app your-app=${DOCKER_IMAGE}:latest -n ${K8S_NAMESPACE} 

                        kubectl rollout status deployment/your-app -n ${K8S_NAMESPACE} 

                        ''' 

                    } 

                } 

            } 

        } 

    } 

  

    post { 

        always { 

            echo 'Cleaning up...' 

        } 

        success { 

            echo 'Deployment successful!' 

        } 

        failure { 

            echo 'Deployment failed.' 

        } 

    } 

}
