// Testing GitHub webhook integration

pipeline {
    agent any

    options {
        // Skip default automatic checkout since we handle it explicitly in the stages
        skipDefaultCheckout(true)
        // Keep build history clean
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    tools {
        maven 'Maven-3.9.9'
        jdk 'JDK21'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Downloading source code from GitHub...'
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[url: 'https://github.com/erictita/devops-trends.git']]
                ])
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling the application...'
                sh 'mvn -B clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Running application tests...'
                sh 'mvn -B test'
            }
        }

        stage('Package') {
            steps {
                echo 'Creating the WAR file...'
                sh 'mvn -B package -DskipTests'
                // Ensure the war file actually exists before proceeding
                sh 'test -f target/devops-trends.war'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying the application to Tomcat...'
                
                // Note: Ensure the Jenkins server can reach 172.31.38.176 on port 8090
                deploy adapters: [
                    tomcat9(
                        credentialsId: 'TomcatCreds',
                        url: 'http://172.31.38.176:8090'
                    )
                ],
                contextPath: '/devops-trends',
                war: 'target/devops-trends.war'
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
            echo 'Application URL: http://13.62.91.108:8090/devops-trends'
        }

        failure {
            echo 'Pipeline failed. Please check the Jenkins Console Output.'
        }

        always {
            echo 'Cleaning up workspace...'
            deleteDir()
        }
    }
}
