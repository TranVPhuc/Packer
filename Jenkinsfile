pipeline {
    agent any

    stages {
        stage('Run Python Script') {
            steps {
                // Cách 1: Viết trực tiếp mã Python trong pipeline
                script {
                    def result = sh(script: 'python3 -c "print(\'Hello from Python!\')"', returnStdout: true).trim()
                    echo "Python output: ${result}"
                }

                // Cách 2: Gọi file script Python đã có sẵn trong repo
                // sh 'python3 my_script.py'
            }
        }
    }
}
