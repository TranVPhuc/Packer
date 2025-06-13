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
                aws autoscaling update-auto-scaling-group \
                  --auto-scaling-group-name $ASG_NAME \
                  --desired-capacity 1 \
                  --region $AWS_REGION
                """
            }
        }

        stage('Wait for agent to connect') {
            steps {
                script {
                    echo "Waiting for agent with label '$AGENT_LABEL'..."
                    timeout(time: 5, unit: 'MINUTES') {
                        waitUntil {
                            def node = Jenkins.instance.nodes.find { 
                                it.getLabelString().contains(env.AGENT_LABEL) &&
                                it.toComputer()?.isOnline()
                            }
                            return node != null
                        }
                    }
                }
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
