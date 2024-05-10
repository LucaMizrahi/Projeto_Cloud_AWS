# app.py

from flask import Flask, jsonify, request
import boto3
from botocore.exceptions import ClientError

# Configurações
app = Flask(__name__)
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('Users_luca')

# Funções Auxiliares
def get_all_users():
    try:
        response = table.scan()
        return response.get('Items', [])
    except ClientError as e:
        app.logger.error(f"Erro ao obter usuarios: {e.response['Error']['Message']}")
        return []

def get_user(user_id):
    try:
        response = table.get_item(Key={'UserID': user_id})
        return response.get('Item', None)
    except ClientError as e:
        app.logger.error(f"Erro ao obter usuario {user_id}: {e.response['Error']['Message']}")
        return None

def create_user(user_id, name):
    try:
        table.put_item(Item={'UserID': user_id, 'Name': name})
        return True
    except ClientError as e:
        app.logger.error(f"Erro ao criar usuario {user_id}: {e.response['Error']['Message']}")
        return False

def delete_user(user_id):
    try:
        table.delete_item(Key={'UserID': user_id})
        return True
    except ClientError as e:
        app.logger.error(f"Erro ao deletar usuario {user_id}: {e.response['Error']['Message']}")
        return False

# Rotas da Aplicação
@app.route('/')
def home():
    return jsonify({'message': 'Bem-vindo a pagina principal!'})

@app.route('/users', methods=['GET', 'POST'])
def users():
    if request.method == 'POST':
        data = request.json
        user_id = str(data['id'])
        name = data['name']
        if create_user(user_id, name):
            return jsonify({'message': 'Usuario criado com sucesso!', 'user': data}), 201
        else:
            return jsonify({'message': 'Erro ao criar usuario.'}), 500
    return jsonify({'users': get_all_users()})

@app.route('/users/<string:user_id>', methods=['GET', 'DELETE'])
def user(user_id):
    if request.method == 'DELETE':
        if delete_user(user_id):
            return jsonify({'message': f'Usuario {user_id} deletado com sucesso!'}), 204
        else:
            return jsonify({'message': f'Erro ao deletar usuario {user_id}.'}), 500
    user = get_user(user_id)
    if user:
        return jsonify(user)
    else:
        return jsonify({'message': f'Usuario {user_id} nao encontrado.'}), 404

# Inicializa a aplicação
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
