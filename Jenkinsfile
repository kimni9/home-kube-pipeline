pipeline {
    agent {
        kubernetes {
            serviceAccount 'jenkins'
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  - name: kubectl
    image: bitnami/kubectl
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 99d
    tty: true
    securityContext:
      runAsUser: 1000
      runAsGroup: 1000
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: regcred
          items:
            - key: .dockerconfigjson
              path: config.json
'''
        }
    }

    stages {
        stage('Checkout') {
            steps {
                // Эта стандартная команда использует код из репозитория,
                // с которым настроен этот Jenkins Pipeline.
                checkout scm
            }
        }
        
        stage('Build and Push Image') {
            steps {
                container('kaniko') {
                    sh '/kaniko/executor --context $PWD --dockerfile $PWD/Dockerfile --destination=ghcr.io/kimni9/my-app:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    sh 'kubectl apply -k k8s/app --v=9'
                }
            }
        }
    }
}
