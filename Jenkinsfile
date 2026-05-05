pipeline {
    agent any

    // Puxa a ferramenta do Scanner que configuramos no Jenkins
    tools {
        sonarScanner 'SonarScanner' 
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Baixando o codigo do repositorio...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Iniciando o Build da aplicacao...'
                bat 'echo "Simulando a compilacao do projeto no Windows..."'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'Rodando testes e enviando para analise no SonarQube...'
                // Usa o servidor SonarQube e o token que configuramos
                withSonarQubeEnv('SonarQube') {
                    // Executa o scanner
                    bat 'sonar-scanner.bat -Dsonar.projectKey=MobEAD -Dsonar.sources=.'
                }
            }
        }

        stage('Deploy - Desenvolvimento') {
            steps {
                echo 'Realizando deploy no ambiente de DEV...'
                bat 'echo "Aplicacao publicada em http://localhost:8080/dev"'
            }
        }

        stage('Aprovacao para Producao') {
            steps {
                // Para a pipeline e pede a liberação (Requisito da Prova!)
                input message: 'Testes em Dev concluidos. Liberar deploy para o ambiente de Producao?', ok: 'Aprovar Deploy'
            }
        }

        stage('Deploy - Producao') {
            steps {
                echo 'Realizando deploy no ambiente de PRODUCAO...'
                bat 'echo "Aplicacao publicada em http://localhost:8080/prod"'
            }
        }
    }
}