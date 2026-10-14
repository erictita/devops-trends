// Testing GitHub webhook integration

pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    tools {
        maven 'Maven 3.9.9'
        jdk 'JDK21'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Downloading source code from GitHub...'

                git branch: 'main',
                    url: 'https://github.com/erictita/devops-trends.git'
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
                sh 'test -f target/devops-trends.war'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying the application to the new Tomcat server...'

                deploy adapters: [
                    tomcat9(
                        credentialsId: 'TomcatCreds',
                        url: 'http://172.31.47.158:8090'
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
            echo 'Application: http://13.49.68.29:8090/devops-trends'
        }

        failure {
            echo 'Pipeline failed. Check the Jenkins Console Output.'
        }

        always {
            echo 'Pipeline finished.'
            deleteDir()
        }
    }
}
