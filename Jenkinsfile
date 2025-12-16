pipeline {
    agent any

    environment {
        PATH = "/opt/maven/bin:$PATH"
    }

    stages {

        stage('Build') {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'puni-sonar-cubeserver'
            }
            steps {
                withSonarQubeEnv('punith-sonar-qubeserver') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}

