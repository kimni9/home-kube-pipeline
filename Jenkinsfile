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
        stage('Clone repository') {
            steps {
                git branch: 'main', 
                    credentialsId: 'github-pat', 
                    url: 'https://github.com/kimni9/home_kube.git'
            }
        }
        
        stage('Build and Push Image') {
            steps {
                container('kaniko') {
                    sh '/kaniko/executor --context $PWD --dockerfile $PWD/docker/Dockerfile --destination=kimni9/my-app:latest'
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
