# Kanban App 🗂️

Aplicação Kanban desenvolvida com **Ruby on Rails**, utilizando **Docker** para padronizar o ambiente de desenvolvimento.
O objetivo do projeto é gerenciar **boards**, **listas** e **tasks**, no estilo Kanban.

---

## 🧱 Stack do Projeto

### Backend
- **Ruby 3.4.8**
- **Ruby on Rails - Rails 8.0.4**
- **PostgreSQL 16**
- **Redis**
- **Sidekiq** (processamento assíncrono)
- **Bundler**

### Infra / DevOps
- **Docker**
- **Docker Compose**
- **WSL (Linux)** recomendado no Windows

---

## 📌 Funcionalidades (Planejadas / Iniciais)

### Boards
- Criar boards
- Cada board representa um fluxo Kanban

### Lists
- Criar listas dentro de um board (ex: To Do, Doing, Done)
- Ordenação por posição

### Tasks
- Criar tasks dentro de uma lista
- Movimentar tasks entre listas
- Ordenação por posição dentro da lista

### Extras
- Processos assíncronos com Sidekiq
- Redis para filas
- Autenticação de usuário

---

## 📂 Estrutura de Containers

- **kanban_app** → Rails (web)
- **sidekiq** → Processamento em background
- **db** → PostgreSQL
- **redis** → Redis
- **Volumes**:
  - `postgres_data`
  - `redis_data`

---

## 🚀 Passo a Passo para Rodar o Projeto

### 1️⃣ Pré-requisitos

Certifique-se de ter instalado:
- Docker
- Docker Compose
- Git

> No Windows, é recomendado usar **WSL2 + Ubuntu**

---

### 2️⃣ Clonar o repositório

```bash
git clone <url-do-repositorio>
cd kanban_app
```
---

### 3️⃣ Build dos containers

```bash
docker-compose build
```

---

### 4️⃣ Subir o ambiente

```bash
docker-compose up
docker compose up -d # em background
```

---

## 5️⃣ Criar o banco de dados - Em outro terminal se não estiver em background

```bash
docker compose run --rm kanban_app bundle exec rails db:create
docker compose run --rm kanban_app bundle exec rails db:migrate
```

Para testes, caso não tenha banco de dados criado:
```bash
docker compose run --rm kanban_app bundle exec rails db:create RAILS_ENV=test
docker compose run --rm kanban_app bundle exec rails db:migrate RAILS_ENV=test
```

---

## 6️⃣ Acessar a aplicação

Acesse o sistema principal em: **[http://localhost:3000](http://localhost:3000)**
Acesse o painel do sidekiq em: **[http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)**

---

## Utilizar Rubocop para subir alguma branch

```bash
docker-compose run --rm kanban_app bundle exec rubocop
```

---

## Para testes unitários rode:

```bash
docker-compose run --rm kanban_app bundle exec rpsec
```

---

## 👷🏾👷🏻 Colaboradores
- [Raphael Willian](https://github.com/RaphaelWillianBarbosadePaula)
- [Davi dos Santos](https://github.com/davisantosp)