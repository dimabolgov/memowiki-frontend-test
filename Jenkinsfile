pipeline {
    agent any
    stages {
        stage('Environment') {
            steps {
                sh 'git --version'
                echo "Branch: ${env.BRANCH_NAME}"
                sh 'docker -v'
                sh 'printenv'
            }
        }
        stage ('Build API') {
            steps {
                build job: 'memowiki-expressjs-test', parameters: [
                    string(name: 'param1', value: "value1")
                ]
            }
        }
        stage('Build React') {
            steps {
                sh 'docker build -t react_v1 -f Dockerfile --no-cache .'
                sh 'docker stop react_v1 || true && docker rm react_v1 || true'
                sh 'ls -la /var/jenkins_home/workspace/simple-node-js-react-npm-app/build'
                sh 'ls -la ./'
                sh 'docker run -d -it -p 4444:80 --net=vnoveprod_app-net --name=react_v1 react_v1'
            }
        }
        stage('Deliver') {
            steps {
                sh 'pwd'
                // input 'Does the staging environment look ok?'
            }
        }
    }
}
