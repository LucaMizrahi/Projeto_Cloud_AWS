# app.py

from flask import Flask, jsonify, request

app = Flask(__name__)

# Rota principal
@app.route('/')
def home():
    return jsonify({'message': 'Bem-vindo à página principal!'})

# Rota de gerenciamento de usuários
@app.route('/users', methods=['GET', 'POST'])
def users():
    if request.method == 'POST':
        data = request.json
        return jsonify({'message': 'Usuário criado com sucesso!', 'user': data}), 201
    return jsonify({'users': [{'id': 1, 'name': 'Alice'}, {'id': 2, 'name': 'Bob'}]})

# Rota para gerenciar um usuário específico
@app.route('/users/<int:user_id>', methods=['GET', 'DELETE'])
def user(user_id):
    if request.method == 'DELETE':
        return jsonify({'message': f'Usuário {user_id} deletado com sucesso!'}), 204
    return jsonify({'id': user_id, 'name': f'User-{user_id}'})

# Inicializa a aplicação
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)