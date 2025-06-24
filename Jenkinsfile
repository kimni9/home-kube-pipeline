pipeline {
    agent any

    stages {
        stage('Checkout Source Code') {
            steps {
                checkout scm
                echo "Code checked out successfully!"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t my-first-jenkins-app .'
                echo "Docker image built!"
            }
        }

        stage('Print Hello') {
            steps {
                echo "Hello from our first Jenkinsfile!"
                sh 'ls -la'
            }
        }
    }
}
