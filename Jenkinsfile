pipeline {
    environment {
        AWS_REGION = 'ap-southeast-1'
        ASG_NAME = 'test-asg'
        AGENT_LABEL = 'agent1'
    }

    agent none

    stages {
        stage('Scale up ASG') {
            agent { label 'agent1' }
            steps {
                echo "Scaling ASG to launch Jenkins agent..."
                sh """
                aws autoscaling update-auto-scaling-group \
                  --auto-scaling-group-name $ASG_NAME \
                  --desired-capacity 1 \
                  --region $AWS_REGION
                """
            }
        }

        stage('Wait for agent to connect') {
            agent { label 'agent1' }
            steps {
                echo "Waiting manually for agent to connect. Please ensure EC2 is running and registered in Jenkins."
                sleep(time: 60, unit: 'SECONDS') // hoặc dùng plugin để check
            }
        }

        stage('Run Python script') {
            agent { label "${env.AGENT_LABEL}" }
            steps {
                echo "Running script on agent: ${env.AGENT_LABEL}"
                writeFile file: 'script.py', text: '''
print("Hello from Jenkins ASG Agent!")
for i in range(3):
    print(f"Step {i+1}")
'''
                sh 'python3 script.py'
            }
        }
    }

    post {
        always {
            agent { label 'agent1' }
            steps {
                echo "Scaling down ASG after job completes..."
                sh """
                aws autoscaling update-auto-scaling-group \
                  --auto-scaling-group-name $ASG_NAME \
                  --desired-capacity 0 \
                  --region $AWS_REGION
                """
            }
        }
    }
}
