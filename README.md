# Projeto AWS CloudFormation

### Luca Mizrahi

## Introdução ao Projeto

### Descrição do Projeto

O projeto AWS CloudFormation tem como objetivo criar uma arquitetura escalável e robusta na AWS para hospedar uma aplicação web. Utilizando o AWS CloudFormation, facilitamos a gestão de recursos e a automação de infraestrutura, permitindo implantações consistentes e repetíveis. A aplicação é distribuída automaticamente entre múltiplas instâncias EC2 através de um Application Load Balancer (ALB), garantindo alta disponibilidade e balanceamento de carga eficiente.

### Topologia da Aplicação

A aplicação é composta por uma instância EC2 que executa um servidor web Flask, conectado a um banco de dados MySQL. O Application Load Balancer (ALB) distribui o tráfego entre as instâncias EC2, garantindo alta disponibilidade e escalabilidade. O Auto Scaling Group monitora a utilização dos recursos e ajusta automaticamente o número de instâncias EC2 conforme necessário. O CloudWatch monitora o desempenho da aplicação e envia alertas caso o uso recursos ultrapasse os limites definidos ou seja menor que o esperado, o que faz com que o Auto Scaling Group ajuste o número de instâncias EC2, para garantir uma maior eficiência e economia de custos.

![Topologia da Aplicação](imgs/diagrama-projeto-cloud.drawio.png)

### Diagrama da Arquitetura AWS

O diagrama da arquitetura AWS mostra a relação entre os diferentes serviços utilizados na aplicação, incluindo EC2, ALB, Auto Scaling Group, Dynamo DB e CloudWatch.

![Diagrama da Arquitetura AWS](imgs/application-composer-application-stack.yaml.png)

### Calculo dos Custos do Projeto
Para estimar os custos associados à arquitetura proposta, utilizamos a AWS Cost Calculator. Esta ferramenta permite modelar e comparar os custos de diferentes configurações de serviços AWS, ajudando a tomar decisões informadas sobre escalabilidade e custo-benefício.

[Estimativa de Custos AWS](https://github.com/LucaMizrahi/Projeto_Cloud_AWS/blob/main/custos_AWS/My%20Estimate%20-%20Calculadora%20de%20Pre%C3%A7os%20da%20AWS.pdf)

Dentre os custos principais estão principalmente 2, sendo eles DynamoDB e Elastic Load Balancer, que são os serviços mais caros da aplicação. Abaixo estão os custos estimados para a aplicação proposta:

1. DynamoDB: $26,39 por/mês (1 tabela com 1GB de armazenamento)

2. Elastic Load Balancer: $16,44 por/mês (1 Application Load Balancer)

>Como possíveis melhorias para redução de custos, podemos citar a utilização de instâncias reservadas ou instâncias spot, que são mais baratas que instâncias sob demanda, e também a utilização de um banco de dados RDS, que é mais barato que o DynamoDB.

## Comandos para utilização da aplicação

### Configuração do Ambiente	

Configuração do ambiente para execução dos comandos:

1. Instale o unzip para descompactar o arquivo de instalação do AWS CLI.

    ```bash
    sudo apt install unzip
    ```

2. Instale o AWS CLI para executar comandos na AWS.

    ```bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    ```
3. Configure o AWS CLI com suas credenciais.

    ```bash
    aws configure
    ```
    **AVISO**: Insira suas credenciais da AWS (Access Key ID e Secret Access Key) e defina a região padrão como `us-east-1`.

### Clone do Repositório

1. Clone o repositório para obter os arquivos necessários para execução dos comandos.

    ```bash
    aws configure
    ```

2. Se precisar faça a instalção do `git`:

    ```bash
    sudo apt install git
    ```
    
### Criação da Stack

- Entre na pasta do projeto para executar os comandos.

    ```bash
    cd <path>
    ```

> Substitua `<path>` pelo caminho onde o repositório foi clonado. 

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

    **OU** 

    >Pelo navegador acesse o link `http://<LoadBalancerDNS>` para acessar a aplicação.

2. Acesse a rota `/users` da aplicação utilizando *curl*

    ```bash
    curl http://<LoadBalancerDNS>/users # Lista todos os usuários
    ```
    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.

    **OU**

    >Pelo navegador acesse o link `http://<LoadBalancerDNS>/users` para listar todos os usuários.
  
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

### Teste do Elastic Auto Scaling com o Locust

Para testar o Elastic Auto Scaling, é necessário primeiro baixar para o locust, que é uma ferramenta de teste de carga, utilizando requests HTTP.

Instale o `locust` pelo pip:

```bash
pip install locust
```

### Utilização do Locust pela interface WEB

1. Execute o comando `locust` para iniciar o servidor web do locust.

    ```bash
    locust -f locustfile.py --host=http://<LoadBalancerDNS>
    ```
    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.
  
2. Acesse a interface web do locust através do link `http://localhost:8089`.

3. Defina o número de usuários e a taxa de usuários por segundo.

    **Sugestão**: Utilize *100* usuários e *10* usuários por segundo.

4. Inicie o teste de carga e observe o comportamento do Auto Scaling Group e do CloudWatch, para confirmar que o Auto Scaling está funcionando corretamente.

### Utilização do Locust pela linha de comando

1. Execute o comando `locust` para iniciar o teste de carga.

    ```bash
    locust -f locustfile.py --host=http://<LoadBalancerDNS> --headless -u 100 -r 10 -t 15m
    ```
    - `-u` ou `--users`: Número de usuários
    - `-r` ou `--spawn-rate`: Taxa de usuários por segundo
    - `-t` ou `--run-time`: Tempo de execução do teste 
    
    **AVISO**: Substitua `<LoadBalancerDNS>` pelo link gerado no comando de obtenção do link do DNS.

2. Observe o comportamento do Auto Scaling Group e do CloudWatch, para confirmar que o Auto Scaling está funcionando corretamente.

Ao final do teste de carga, é possível visualizar os resultados no terminal e é possível perceber que para os parâmetros definidos, o Auto Scaling Group ajustou o número de instâncias EC2 conforme necessário, garantindo alta disponibilidade e eficiência na utilização de recursos, sem que houvesse falhas ou interrupções na aplicação. 

![Instâncias criadas pelo Auto Scaling Group](imgs/Instancias_TesteLocust.png)

Lembrando que o máximo de instâncias que podem ser criadas foi definido em 5, logo o Auto Scaling Group conseguiu escalar o número de instâncias conforme necessário, sem ultrapassar o limite definido.

![Resultado do Teste de Carga](imgs/Resultado_TesteLocust.png)

O Resultado do Teste de Carga mostra que a aplicação foi capaz de lidar com a carga de 100 usuários fazendo em média 30 requisições por segundo, sem que houvesse falhas ou interrupções, garantindo alta disponibilidade e eficiência na utilização de recursos.

### Análise de Custos Real por meio da aba Billing AWS

Como não conseguimos acessar a aba de `Tags de Alocação de Custos` para visualizar os custos reais da aplicação, podemos acessar a aba de `Billing` da AWS para visualizar os custos reais da aplicação. 

Para acessar a aba de `Billing` da AWS, siga os passos abaixo:

1. Acesse o Console da AWS.

2. Pesquisar por `Billing and Cost Managment` na barra de pesquisa. 

![Custos Reais da Aplicação](imgs/Custos_Reais.png)

*Imagem Obtida na Data: 20/05/2024*

Considerando que o uso de recursos se manterá como foi realizado no período de MTD (Month-to-date) atual, o custo mensal da aplicação seria de algo em torno de **$35,66 dólares/mês** (projeção da própria AWS com base no uso passado dos recursos considerando as duas contas - Minha e do Gustavo). Assim, é possível perceber que a projeção real de custos utilizando o billing é consideravelmente menor que utilizando a calculador de custos da AWS, que chegou em um valor de **$55,93 dólares/mês**.

No entanto é muito importante ressaltar que uma parte dessa projeção é imprecisa porque houve gastos que envolvem o aprendizado dos recursos da AWS, mas a realidade é que esses gastos não seriam recorrentes, logo o custo real da aplicação seria provavelmente menor do que o projetado pela AWS na aba de billing.