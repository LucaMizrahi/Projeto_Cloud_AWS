from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)  # Espera entre 1 e 5 segundos entre as tarefas

    @task
    def index(self):
        self.client.get("/")  # Acessa a página principal

    @task(3)
    def load_users(self):
        self.client.get("/users")  # Acessa a rota de usuários, mais frequente

    @task(1)
    def create_user(self):
        self.client.post("/users", json={"id": "123", "name": "John Doe"})  # Cria um novo usuário
