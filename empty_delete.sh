#!/bin/bash

# Variáveis
BUCKET_NAME="bucket-projeto-lucam"
STACK_NAME="application-stack"
REGION="us-east-1"

# Função para esvaziar o bucket S3
empty_bucket() {
  echo "Tentando esvaziar o bucket: $BUCKET_NAME..."
  aws s3 rm s3://$BUCKET_NAME --recursive

  if [ $? -eq 0 ]; then
    echo "Bucket $BUCKET_NAME esvaziado com sucesso."
  else
    echo "Erro ao esvaziar o bucket $BUCKET_NAME. Verifique se o bucket existe ou se há problemas de permissão."
    exit 1
  fi
}

# Função para deletar o bucket S3
delete_bucket() {
  echo "Tentando deletar o bucket: $BUCKET_NAME..."
  aws s3api delete-bucket --bucket $BUCKET_NAME --region $REGION

  if [ $? -eq 0 ]; then
    echo "Bucket $BUCKET_NAME deletado com sucesso."
  else
    echo "Erro ao deletar o bucket $BUCKET_NAME. Verifique se o bucket já foi esvaziado e se há problemas de permissão."
    exit 1
  fi
}

# Função para deletar a stack CloudFormation
delete_stack() {
  echo "Tentando deletar a stack CloudFormation: $STACK_NAME..."
  aws cloudformation delete-stack --stack-name $STACK_NAME

  if [ $? -eq 0 ]; then
    echo "Stack $STACK_NAME deletada com sucesso."
  else
    echo "Erro ao deletar a stack $STACK_NAME. Verifique as mensagens de erro do CloudFormation para mais detalhes."
    exit 1
  fi
}

# Função para deletar o secret do AWS Secret Manager
delete_secret() {
  echo "Tentando deletar o AWS Secret Manager: $SECRET_NAME..."
  aws secretsmanager delete-secret --secret-id $SECRET_NAME --force-delete-without-recovery

  if [ $? -eq 0 ]; then
    echo "Secret $SECRET_NAME deletado com sucesso."
  else
    echo "Erro ao deletar o secret $SECRET_NAME. Verifique as mensagens de erro do AWS Secret Manager para mais detalhes."
    exit 1
  fi
}

# Chamar funções
empty_bucket
delete_bucket
delete_stack
