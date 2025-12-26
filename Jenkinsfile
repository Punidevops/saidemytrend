def registry = "https://trial10puneeth.jfrog.io"

pipeline {
    agent any

    environment {
        PATH = "/opt/maven/bin:${env.PATH}"
    }

    stages {

        stage("Build") {
            steps {
                echo "--------- Build started ---------"
                sh "mvn clean package -Dmaven.test.skip=true"
                echo "--------- Build completed ---------"
            }
        }

        stage("Unit Test") {
            steps {
                echo "--------- Unit test started ---------"
                sh "mvn surefire-report:report"
                echo "--------- Unit test completed ---------"
            }
        }

        stage("SonarQube Analysis") {
            environment {
                scannerHome = tool 'puni-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('punith-sonar-qubeserver') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage("Jar Publish to JFrog") {
            steps {
                script {
                    echo "<------------- Jar Publish Started ------------->"

                    def server = Artifactory.newServer(
                        url: "${registry}/artifactory",
                        credentialsId: "jfrog-cred"
                    )

                    def properties = "buildid=${env.BUILD_ID},commitid=${env.GIT_COMMIT}"

                    def uploadSpec = """
                    {
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "punijfrogrepo-libs-release-local/",
                                "flat": "true",
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }
                    """

                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                }
            }
        }
    }
}

