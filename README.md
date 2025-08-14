# 🏍️ Pátio API - Sistema de Gerenciamento de Motos

API REST para gerenciamento de pátios e motos, desenvolvida com Spring Boot 3 e Java 17.

## 🚀 Funcionalidades

- ✅ **Gerenciamento de Pátios**: CRUD completo para pátios
- ✅ **Gerenciamento de Motos**: CRUD completo para motos
- ✅ **Relacionamento**: Motos associadas a pátios
- ✅ **Status de Motos**: Controle de status (DISPONIVEL, ALUGADA, MANUTENCAO)
- ✅ **Documentação**: Swagger/OpenAPI 3 integrado
- ✅ **Frontend**: Interface web para visualização
- ✅ **Banco H2**: Para desenvolvimento local
- ✅ **PostgreSQL**: Para produção (Supabase)

## 🛠️ Tecnologias

- **Java 17**
- **Spring Boot 3.4.5**
- **Spring Data JPA**
- **H2 Database** (desenvolvimento)
- **PostgreSQL** (produção)
- **Maven**
- **Swagger/OpenAPI 3**
- **Bootstrap 5** (frontend)

## 🏃‍♂️ Executando Localmente

### Pré-requisitos
- Java 17+
- Maven 3.6+

### 1. Clone o repositório
```bash
git clone <url-do-repositorio>
cd patio-api
```

### 2. Execute a aplicação
```bash
# Windows
.\mvnw.cmd spring-boot:run

# Linux/Mac
./mvnw spring-boot:run
```

### 3. Acesse a aplicação
- **Frontend**: http://localhost:8090
- **API**: http://localhost:8090/api
- **Swagger**: http://localhost:8090/swagger-ui/index.html
- **Console H2**: http://localhost:8090/h2-console
  - URL: `jdbc:h2:mem:testdb`
  - User: `sa`
  - Password: (vazio)

### 4. Popular dados de teste
```powershell
.\popular_dados_simples.ps1
```

## 🌐 Deploy em Produção

### Railway (Recomendado)

1. **Configurar Supabase**:
   - Crie uma conta no [Supabase](https://supabase.com)
   - Crie um novo projeto
   - Obtenha as credenciais de conexão

2. **Deploy no Railway**:
   - Acesse [Railway](https://railway.app)
   - Conecte seu repositório GitHub
   - Configure as variáveis de ambiente:
     ```
     SPRING_PROFILES_ACTIVE=prod
     SUPABASE_DB_URL=jdbc:postgresql://[HOST]:5432/postgres?sslmode=require
     SUPABASE_DB_USERNAME=postgres
     SUPABASE_DB_PASSWORD=[SUA_SENHA]
     PORT=8080
     ```

3. **Documentação completa**: Ver [README-RAILWAY.md](README-RAILWAY.md)

### Outras Plataformas
- **Render**: Ver [README-SUPABASE.md](README-SUPABASE.md)
- **Heroku**: Compatível com as mesmas configurações

## 📚 Documentação da API

### Endpoints Principais

#### Pátios
- `GET /api/patios` - Listar todos os pátios
- `GET /api/patios/{id}` - Buscar pátio por ID
- `POST /api/patios` - Criar novo pátio
- `PUT /api/patios/{id}` - Atualizar pátio
- `DELETE /api/patios/{id}` - Excluir pátio

#### Motos
- `GET /api/motos` - Listar todas as motos
- `GET /api/motos/{id}` - Buscar moto por ID
- `POST /api/motos` - Criar nova moto
- `PUT /api/motos/{id}` - Atualizar moto
- `DELETE /api/motos/{id}` - Excluir moto
- `GET /api/motos/status/{status}` - Buscar motos por status
- `GET /api/motos/patio/{patioId}` - Buscar motos de um pátio

### Modelos de Dados

#### Pátio
```json
{
  "id": 1,
  "nome": "Pátio Central",
  "endereco": "Rua das Flores, 123",
  "telefone": "(11) 99999-9999"
}
```

#### Moto
```json
{
  "id": 1,
  "marca": "Honda",
  "modelo": "CB 600F",
  "ano": 2023,
  "placa": "ABC-1234",
  "cor": "Vermelha",
  "status": "DISPONIVEL",
  "patio": {
    "id": 1,
    "nome": "Pátio Central"
  }
}
```

#### Status de Moto
- `DISPONIVEL` - Moto disponível para aluguel
- `ALUGADA` - Moto atualmente alugada
- `MANUTENCAO` - Moto em manutenção

## 🧪 Testes

### Executar testes
```bash
# Windows
.\mvnw.cmd test

# Linux/Mac
./mvnw test
```

### Testar API com curl
```bash
# Listar pátios
curl http://localhost:8090/api/patios

# Criar pátio
curl -X POST http://localhost:8090/api/patios \
  -H "Content-Type: application/json" \
  -d '{"nome":"Novo Pátio","endereco":"Rua Nova, 456","telefone":"(11) 88888-8888"}'

# Listar motos
curl http://localhost:8090/api/motos
```

## 📁 Estrutura do Projeto

```
src/
├── main/
│   ├── java/com/patio/
│   │   ├── PatioApiApplication.java
│   │   ├── controller/
│   │   │   ├── PatioController.java
│   │   │   └── MotoController.java
│   │   ├── model/
│   │   │   ├── Patio.java
│   │   │   ├── Moto.java
│   │   │   └── StatusMoto.java
│   │   ├── repository/
│   │   │   ├── PatioRepository.java
│   │   │   └── MotoRepository.java
│   │   └── service/
│   │       ├── PatioService.java
│   │       └── MotoService.java
│   └── resources/
│       ├── application.properties
│       ├── application-prod.properties
│       ├── static/
│       └── templates/
└── test/
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Suporte

Para dúvidas ou suporte:
- Abra uma [issue](../../issues)
- Consulte a [documentação completa](README-RAILWAY.md)
- Acesse o [Swagger UI](http://localhost:8090/swagger-ui/index.html) para testar a API

---

**✨ Desenvolvido com Spring Boot e ❤️**