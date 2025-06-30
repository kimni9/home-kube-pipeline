pipeline {
    agent {
        kubernetes {
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
    - cat
    tty: true
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
                    sh '/kaniko/executor --context $PWD --dockerfile $PWD/Dockerfile --destination=kimni9/my-app:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    sh 'kubectl apply -k k8s/overlays/dev'
                }
            }
        }
    }
}
