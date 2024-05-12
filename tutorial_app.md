# Projeto AWS CloudFormation

### Luca Mizrahi

## Comandos para utilização da aplicação

### Criação da Stack 

Comandos para criação da stack: 

```bash
chmod +x create_and_upload.sh
./create_and_upload.sh
```
Com esses 2 comandos é possível deixar o script executável, e executar o script que faz upload da aplicação para o bucket da AWS e cria a stack. 

Após alguns minutos a stack estará criada e será possível acessar a aplicação através do link que será gerado no output da stack.

Comando para obter o link da aplicação (DNS do Load Balancer): 

```bash
aws cloudformation describe-stacks --stack-name application-stack \
  --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerDNSName`].OutputValue' \
  --output text
```
**AVISO**: Armazene o link gerado com o comando acima, pois ele será utilizado para testar a aplicação.

### Teste da Aplicação

Agora que a aplicação está rodando, será utilizado o link gerado no comando anterior para testar a aplicação.

1. Acesse a rota principal da aplicação utilizando *curl*
    
    ```bash 
    curl http://<LoadBalancerDNS> # Rota Principal
    ```
    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.

2. Acesse a rota `/users` da aplicação utilizando *curl*

    ```bash
    curl http://<LoadBalancerDNS>/users # Lista todos os usuários
    ```
    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.
  
3. Crie um usuário no banco de dados

    ```bash
    curl -X POST http://<LoadBalancerDNS>/users \
    -H "Content-Type: application/json" \
    -d '{"id": "1", "name": "Luca"}' # Criar um Novo Usuário
    ```
    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.

4. Acesse a rota `/users` da aplicação utilizando *curl*

    ```bash
    curl http://<LoadBalancerDNS>/users # Lista todos os usuários
    ```
    OU 

    ```bash
    curl http://<LoadBalancerDNS>/users/1 # Lista um usuário específico pelo ID
    ```

    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.
  
5. Delete um usuário do banco de dados

    ```bash
    curl -X DELETE http://<LoadBalancerDNS>/users/1 # Deletar um Usuário pelo ID
    ```
    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.

### Update da Stack

Para atualizar a stack, é necessário alterar o arquivo `template.yaml` e executar o script `update_stack.sh`.

1. Altere o arquivo `template.yaml` conforme necessário.

2. Execute o script `update_stack.sh` para atualizar a stack.

    ```bash
    chmod +x update_stack.sh
    ./update_stack.sh
    ```
    **AVISO**: O script irá atualizar a stack com as alterações feitas no arquivo `template.yaml`.

### Delete da Stack

1. Execute o script `delete_stack.sh` para deletar a esvaziar o bucket, deletar o bucket e também deletar a stack.

    ```bash
    chmod +x update_stack.sh
    ./update_stack.sh
    ```
    **AVISO**: O script irá deletar a stack e não será mais possível utilizar a aplicação.

### Calculo dos Custos do Projeto

Os custos foram calculados utilizando 

### Teste do Elastic Auto Scaling

Para testar o Elastic Auto Scaling, é necessário utilizar o comando `stress` para simular uma alta carga na aplicação.

1. Instale o `stress` na instância EC2

    ```bash
    sudo apt-get install -y stress
    ```
2. Execute o comando `stress` para simular uma alta carga na aplicação

    ```bash
    stress --cpu 8 --timeout 300
    ```
    **AVISO**: O comando acima irá simular uma alta carga na aplicação por 5 minutos.
  
3. Acesse o console da AWS e verifique o Auto Scaling Group e o Load Balancer para ver a quantidade de instâncias que foram criadas.