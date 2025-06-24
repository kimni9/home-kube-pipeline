pipeline {
    agent any

    stages {
        stage('Checkout Source Code') {
            steps {
                checkout scm
                echo "Code checked out successfully!"
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
