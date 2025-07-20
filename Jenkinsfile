pipeline {
    agent any
    
    options {
        // Critical: Don't wipe workspace between builds to preserve state
        disableConcurrentBuilds()
        // Keep logs but don't disturb workspace
        buildDiscarder(logRotator(daysToKeepStr: '30', numToKeepStr: '10'))
    }
    
    triggers {
        pollSCM('* * * * *')
    }
    
    environment {
        // Use consistent credentials
        AWS_CREDS = credentials('aws-credentials')
        // Add this to ensure AWS provider stability
        TF_CLI_ARGS="-no-color"
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Don't clean workspace between builds to preserve state
                checkout([$class: 'GitSCM',
                    branches: [[name: 'master']],
                    extensions: [[$class: 'CleanCheckout', 
                                 deleteUntrackedNestedRepositories: false]],
                    userRemoteConfigs: [[url: 'https://github.com/dmshiv/Global-accelerator.git',
                                       credentialsId: 'github-credentials']]
                ])
                echo "📂 Code checkout complete"
            }
        }
        
        // MUMBAI - BROKEN INTO CLEAR STAGES
        stage('Mumbai-Init') {
            steps {
                dir('mumbai') {
                    sh 'terraform init -input=false'
                    echo "✅ Mumbai initialization complete"
                }
            }
        }
        
        stage('Mumbai-Refresh') {
            steps {
                dir('mumbai') {
                    sh 'terraform refresh'
                    sh 'terraform state list | grep -q "aws_instance" || echo "No existing instances found"'
                    echo "✅ Mumbai state refreshed"
                }
            }
        }
        
        stage('Mumbai-Plan') {
            steps {
                dir('mumbai') {
                    sh 'terraform plan -detailed-exitcode -out=mumbai-tfplan || true'
                    echo "✅ Mumbai plan created"
                }
            }
        }

                // Add this before each plan stage
        stage('Mumbai-State-Check') {
            steps {
                dir('mumbai') {
                    sh '''
                    if [ -f terraform.tfstate ]; then
                      echo "State file exists, checking resources..."
                      terraform state list
                    else
                      echo "WARNING: No state file found! This may cause duplicate resources."
                    fi
                    '''
                }
            }
        }
        











        stage('Mumbai-Apply') {
    steps {
        dir('mumbai') {
            sh '''
            # Ensure backup is always created
            terraform apply -backup=terraform.tfstate.backup -input=false mumbai-tfplan
            
            # Copy the current state to an additional timestamped backup
            cp terraform.tfstate "terraform.tfstate.backup.$(date +%Y%m%d%H%M%S)"
            '''
        }
    }
}
        
        // IRELAND - BROKEN INTO CLEAR STAGES
        stage('Ireland-Init') {
            steps {
                dir('ireland') {
                    sh 'terraform init -input=false'
                    echo "✅ Ireland initialization complete"
                }
            }
        }
        
        stage('Ireland-Refresh') {
            steps {
                dir('ireland') {
                    sh 'terraform refresh'
                    sh 'terraform state list | grep -q "aws_instance" || echo "No existing instances found"'
                    echo "✅ Ireland state refreshed"
                }
            }
        }
        
        stage('Ireland-Plan') {
            steps {
                dir('ireland') {
                    sh 'terraform plan -detailed-exitcode -out=ireland-tfplan || true'
                    echo "✅ Ireland plan created"
                }
            }
        }

                // Add this before each plan stage
        stage('Ireland-State-Check') {
            steps {
                dir('ireland') {
                    sh '''
                    if [ -f terraform.tfstate ]; then
                      echo "State file exists, checking resources..."
                      terraform state list
                    else
                      echo "WARNING: No state file found! This may cause duplicate resources."
                    fi
                    '''
                }
            }
        }



















        
        stage('Ireland-Apply') {
    steps {
        dir('ireland') {
            sh '''
            # Ensure backup is always created
            terraform apply -backup=terraform.tfstate.backup -input=false ireland-tfplan
            
            # Copy the current state to an additional timestamped backup
            cp terraform.tfstate "terraform.tfstate.backup.$(date +%Y%m%d%H%M%S)"
            '''
        }
    }
}
        
        // ACCELERATOR - BROKEN INTO CLEAR STAGES
        stage('Accelerator-Init') {
            steps {
                dir('accelerator-file') {
                    sh 'terraform init -input=false'
                    echo "✅ Accelerator initialization complete"
                }
            }
        }
        
        stage('Accelerator-Refresh') {
            steps {
                dir('accelerator-file') {
                    sh 'terraform refresh'
                    sh 'terraform state list | grep -q "aws_globalaccelerator" || echo "No existing accelerator found"'
                    echo "✅ Accelerator state refreshed"
                }
            }
        }
        
        stage('Accelerator-Plan') {
            steps {
                dir('accelerator-file') {
                    sh 'terraform plan -detailed-exitcode -out=accelerator-tfplan || true'
                    echo "✅ Accelerator plan created"
                }
            }
        }

                // Add this before each plan stage
        stage('Accelerator-State-Check') {
            steps {
                dir('accelerator-file') {
                    sh '''
                    if [ -f terraform.tfstate ]; then
                      echo "State file exists, checking resources..."
                      terraform state list
                    else
                      echo "WARNING: No state file found! This may cause duplicate resources."
                    fi
                    '''
                }
            }
        }

        




















        
        stage('Accelerator-Apply') {
    steps {
        dir('accelerator-file') {
            sh '''
            # Ensure backup is always created
            terraform apply -backup=terraform.tfstate.backup -input=false accelerator-tfplan
            
            # Copy the current state to an additional timestamped backup
            cp terraform.tfstate "terraform.tfstate.backup.$(date +%Y%m%d%H%M%S)"
            '''
        }
    }
}
        
        stage('Deployment-Complete') {
            steps {
                echo "=========================================="
                echo "🎉 DEPLOYMENT COMPLETED SUCCESSFULLY! 🎉"
                echo "=========================================="
            }
        }
    }
    
    post {
        success {
            echo "✅ Pipeline succeeded"
            // Archive state files but don't delete them
            archiveArtifacts artifacts: '**/terraform.tfstate', allowEmptyArchive: true
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}