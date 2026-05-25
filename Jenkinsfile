pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'
        jdk 'JDK21'
    }

    environment {
        WAR_FILE = 'target/devops-trends.war'
        TOMCAT_URL = 'http://localhost:8080'
        CONTEXT_PATH = '/devops-trends'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Pulling source code from GitHub...'
                git branch: 'main',
                    credentialsId: 'GitHubCreds',
                    url: 'https://github.com/erictita/devops-trends.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling the application...'
                bat 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                bat 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging into WAR file...'
                bat 'mvn package -DskipTests'
            }
        }

        stage('Check Tomcat') {
            steps {
                echo "Checking Tomcat availability at ${TOMCAT_URL}"
                bat 'powershell -NoProfile -Command "try { Invoke-WebRequest -Uri ''%TOMCAT_URL%'' -UseBasicParsing -TimeoutSec 10 } catch { exit 1 }"'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying to local Tomcat...'
                deploy adapters: [
                    tomcat9(
                        credentialsId: 'TomcatCreds',
                        url: "${TOMCAT_URL}"
                    )
                ],
                contextPath: "${CONTEXT_PATH}",
                war: "${WAR_FILE}"
            }
        }

    }

    post {
        success {
            echo 'Deployment successful!'
            echo "App running at: ${TOMCAT_URL}${CONTEXT_PATH}"
        }
        failure {
            echo 'Pipeline failed. Check console output for details.'
        }
        always {
            echo 'Pipeline finished. Cleaning workspace...'
            deleteDir()
        }
    }
}