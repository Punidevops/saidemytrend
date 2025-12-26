def registry = https:'//trial10puneeth.jfrog.io/'
pipeline {
    agent any

    environment {
        PATH = "/opt/maven/bin:$PATH"
    }

    stages {

        stage("build") {
            steps {
                echo "--------- build started ---------"
                sh "mvn clean deploy -Dmaven.test.skip=true"
                echo "--------- build completed ---------"
            }
        }

        stage("test") {
            steps {
                echo "--------- unit test started ---------"
                sh "mvn surefire-report:report"
                echo "--------- unit test completed ---------"
            }
        }

        stage("SonarQube analysis") {
            environment {
                scannerHome = tool 'puni-sonar-cubeserver'
            }
            steps {
                withSonarQubeEnv('punith-sonar-qubeserver') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage("Jar Publish") {
            steps {
                script {
                    echo "<------------- Jar Publish Started ------------->"

                    def server = Artifactory.newServer(
                        url: "registry+/artifactory",
                        credentialsId: "jfrog-cred"
                    )

                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"

                    def uploadSpec = """
                    {
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "punijfrogrepo-libs-release-local/{1}",
                                "flat": "false",
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

