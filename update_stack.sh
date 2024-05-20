#!/bin/bash

# Variáveis
STACK_NAME="StackProjetoLucam"
TEMPLATE_FILE="application-deployment.yaml"
APP_FILE="app.py"
AMI="ami-07caf09b362be10b8"
BUCKET_NAME="bucket-projeto-lucam"

# Função para atualizar a stack CloudFormation
update_stack() {
  echo "Tentando atualizar a stack CloudFormation $STACK_NAME..."
  aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters \
      ParameterKey=AppS3File,ParameterValue=$APP_FILE \
      ParameterKey=AMI,ParameterValue=$AMI \
      ParameterKey=BucketName,ParameterValue=$BUCKET_NAME \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

  if [ $? -eq 0 ]; then
    echo "Stack $STACK_NAME atualizada com sucesso."
  else
    echo "Erro ao atualizar a stack $STACK_NAME. Verifique as mensagens de erro do CloudFormation para mais detalhes."
    exit 1
  fi
}

# Fluxo principal
update_stack
