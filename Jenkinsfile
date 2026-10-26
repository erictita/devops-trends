```groovy
pipeline {
    agent any

    tools {
        maven 'Maven 3.9.9'
        jdk 'JDK21'
    }

    environment {
        WAR_FILE = 'target/devops-trends.war'
        TOMCAT_URL = 'http://16.16.14.133:8081'
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
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging into WAR file...'
                sh 'mvn package -DskipTests'
            }
        }

        stage('Check Tomcat') {
            steps {
                echo "Checking Tomcat availability at ${TOMCAT_URL}"
                sh '''
                    curl -fsS --max-time 10 "$TOMCAT_URL" -o /dev/null
                '''
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "Deploying application to Tomcat at ${TOMCAT_URL}..."

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
            echo "App URL: ${TOMCAT_URL}${CONTEXT_PATH}"
        }

        failure {
            echo 'Pipeline failed. Check the console output for details.'
        }

        always {
            echo 'Pipeline finished. Cleaning workspace...'
            deleteDir()
        }
    }
}
```
