pipeline {
    environment {
        AWS_REGION = 'ap-southeast-1'
        ASG_NAME = 'test-asg'
        AGENT_LABEL = 'agent1'
    }

    agent any

    stages {
        stage('Scale up ASG') {
            steps {
                echo "Scaling ASG to launch Jenkins agent..."
                sh """
                set -e
                aws autoscaling update-auto-scaling-group \
                  --auto-scaling-group-name "$ASG_NAME" \
                  --desired-capacity 1 \
                  --region "$AWS_REGION"
                """
            }
        }

        stage('Wait for agent to connect') {
            steps {
                echo "Waiting for agent to connect..."
                sleep(time: 60, unit: 'SECONDS') // Could be replaced with retry/wait logic
            }
        }

        stage('Run Python script') {
            agent { label "${env.AGENT_LABEL}" }
            steps {
                echo "Cloning repo and running Python script on agent: ${env.AGENT_LABEL}"

                // Clone repo từ GitHub hoặc GitLab
                sh 'git clone https://github.com/TranVPhuc/Packer.git'

                // Di chuyển vào thư mục repo và chạy file Python
                sh 'cd Packer && python3 main.py'
            }
        }
    }

    post {
        always {
            echo "Scaling down ASG after job completes..."
            sh """
            set -e
            aws autoscaling update-auto-scaling-group \
              --auto-scaling-group-name "$ASG_NAME" \
              --desired-capacity 0 \
              --region "$AWS_REGION"
            """
        }
    }
}
