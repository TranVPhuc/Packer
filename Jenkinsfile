pipeline {
    agent { label 'agent1' }

    stages {
        stage('Run Python Script') {
            steps {
                script {
                    def result = sh(script: 'python3 -c "print(\'Hello from Python on agent1!\')"', returnStdout: true).trim()
                    echo "Python output: ${result}"
                }
            }
        }
    }
}
