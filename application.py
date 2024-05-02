import boto3

# Criar o cliente DynamoDB
dynamodb = boto3.resource('dynamodb')

# Nome da tabela
table_name = 'Users'

# Função para criar um usuário
def create_user(user_id, user_name, email):
    table = dynamodb.Table(table_name)
    response = table.put_item(
       Item={
            'UserId': user_id,
            'UserName': user_name,
            'Email': email
        }
    )
    return response

# Função para listar todos os usuários
def list_users():
    table = dynamodb.Table(table_name)
    response = table.scan()
    return response['Items']

# Função para deletar um usuário
def delete_user(user_id):
    table = dynamodb.Table(table_name)
    response = table.delete_item(
        Key={
            'UserId': user_id
        }
    )
    return response

# Usando as funções
if __name__ == "__main__":
    # Criar um usuário
    print(create_user('001', 'John Doe', 'john.doe@example.com'))

    # Listar todos os usuários
    print(list_users())

    # Deletar um usuário
    print(delete_user('001'))
