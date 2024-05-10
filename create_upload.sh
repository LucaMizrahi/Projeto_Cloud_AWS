#!/bin/bash

# Variáveis
BUCKET_NAME="bucket-projeto-lucam"
STACK_NAME="application-stack"
APP_FILE="app.py"
REGION="us-east-1"
TEMPLATE_FILE="application-deployment.yaml"

# Função para criar o bucket S3
create_bucket() {
  echo "Tentando criar o bucket: $BUCKET_NAME..."

  if [ "$REGION" == "us-east-1" ]; then
    aws s3api create-bucket --bucket $BUCKET_NAME
  else
    aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION
  fi

  if [ $? -eq 0 ]; then
    echo "Bucket $BUCKET_NAME criado com sucesso."
    return 0
  else
    echo "Erro ao criar o bucket $BUCKET_NAME. Verifique se ele já existe ou se há um problema de permissão."
    return 1
  fi
}

# Função para fazer upload do arquivo Python
upload_app_file() {
  echo "Tentando fazer upload do arquivo $APP_FILE para o bucket $BUCKET_NAME..."
  aws s3 cp $APP_FILE s3://$BUCKET_NAME/

  if [ $? -eq 0 ]; then
    echo "Arquivo $APP_FILE enviado para o bucket $BUCKET_NAME com sucesso."
    return 0
  else
    echo "Erro ao fazer upload do arquivo $APP_FILE para o bucket $BUCKET_NAME. Verifique suas permissões ou a existência do arquivo."
    return 1
  fi
}

# Função para criar a stack CloudFormation
create_stack() {
  echo "Tentando criar a stack CloudFormation $STACK_NAME..."
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters \
      ParameterKey=AppS3File,ParameterValue=$APP_FILE \
      ParameterKey=AMI,ParameterValue="ami-07caf09b362be10b8" \
      ParameterKey=BucketName,ParameterValue=$BUCKET_NAME \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

  if [ $? -eq 0 ]; then
    echo "Stack $STACK_NAME criada com sucesso."
  else
    echo "Erro ao criar a stack $STACK_NAME. Verifique as mensagens de erro do CloudFormation para mais detalhes."
    exit 1
  fi
}

# Fluxo principal
create_bucket
if [ $? -eq 0 ]; then
  upload_app_file
  if [ $? -eq 0 ]; then
    create_stack
  else
    echo "Erro ao fazer upload do arquivo Python. A stack não será criada."
    exit 1
  fi
else
  echo "Erro ao criar o bucket. A stack não será criada."
  exit 1
fi
