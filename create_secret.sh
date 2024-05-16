#!/bin/bash

# VARIÁVEIS
SECRET_NAME="github-secret"
SECRET_FILE="secrets.json"

# FUNÇÃO PARA CRIAR O SECRET
create_secret() {
  echo "Tentando criar o AWS Secret Manager..."
  aws secretsmanager create-secret \
    --name $SECRET_NAME \
    --description "Secret para acesso ao banco de dados" \
    --secret-string file://$SECRET_FILE

  if [ $? -eq 0 ]; then
    echo "Secret $SECRET_NAME criado com sucesso."
  else
    echo "Erro ao criar o secret $SECRET_NAME. Verifique as mensagens de erro do AWS Secret Manager para mais detalhes."
    exit 1
  fi
}