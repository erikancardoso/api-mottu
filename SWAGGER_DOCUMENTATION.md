# Documentação Swagger - Pátio API

## Acesso à Documentação

Após iniciar a aplicação, a documentação Swagger estará disponível em:

- **Swagger UI**: http://localhost:8080/swagger-ui/index.html
- **OpenAPI JSON**: http://localhost:8080/v3/api-docs

## Funcionalidades Implementadas

### 1. Configuração SpringDoc OpenAPI 3

- Migração do Swagger Core 2 para SpringDoc OpenAPI 3 (padrão atual para Spring Boot 3)
- Configuração completa da API com metadados:
  - Título: "Pátio API"
  - Versão: "1.0.0"
  - Descrição detalhada
  - Informações de contato e licença
  - Servidores de desenvolvimento e produção

### 2. Documentação dos Controllers

#### PatioController
- **POST /api/patios** - Criar novo pátio
- **GET /api/patios** - Listar pátios (com paginação)
- **GET /api/patios/{id}** - Buscar pátio por ID
- **PUT /api/patios/{id}** - Atualizar pátio
- **DELETE /api/patios/{id}** - Excluir pátio

#### MotoController
- **POST /api/motos** - Criar nova moto
- **GET /api/motos** - Listar motos (com paginação e filtro por status)
- **GET /api/motos/{id}** - Buscar moto por ID
- **PUT /api/motos/{id}** - Atualizar moto
- **DELETE /api/motos/{id}** - Excluir moto

### 3. Documentação dos DTOs

Todos os DTOs foram documentados com anotações `@Schema`:

- **PatioCreateDTO**: Dados para criação de pátio
- **PatioDTO**: Dados de resposta de pátio
- **MotoCreateDTO**: Dados para criação de moto
- **MotoDTO**: Dados de resposta de moto
- **MotoUpdateDTO**: Dados para atualização de moto

### 4. Anotações Utilizadas

- `@Tag`: Agrupamento de endpoints por controller
- `@Operation`: Descrição detalhada de cada endpoint
- `@ApiResponses` / `@ApiResponse`: Documentação de códigos de resposta HTTP
- `@Parameter`: Documentação de parâmetros de entrada
- `@Content` / `@Schema`: Documentação de schemas de request/response

### 5. Exemplos e Validações

- Exemplos de valores para todos os campos
- Valores permitidos para campos com opções limitadas (ex: status da moto)
- Indicação de campos obrigatórios
- Descrições claras para cada campo

## Como Testar

1. Acesse http://localhost:8080/swagger-ui/index.html
2. Explore os endpoints disponíveis
3. Use o botão "Try it out" para testar as operações
4. Verifique os schemas de request/response
5. Teste diferentes cenários (sucesso, erro, validação)

## Benefícios da Implementação

- **Documentação Automática**: Gerada automaticamente a partir do código
- **Interface Interativa**: Permite testar endpoints diretamente
- **Padrão da Indústria**: Segue especificação OpenAPI 3.0
- **Facilita Integração**: Desenvolvedores podem entender rapidamente a API
- **Manutenção Simplificada**: Documentação sempre atualizada com o código

## Estrutura dos Status de Moto

- `DISPONIVEL`: Moto disponível para aluguel
- `EM_MANUTENCAO`: Moto em manutenção
- `ALUGADA`: Moto atualmente alugada

## Códigos de Resposta HTTP

- **200**: Operação realizada com sucesso
- **201**: Recurso criado com sucesso
- **204**: Recurso excluído com sucesso
- **400**: Dados inválidos fornecidos
- **404**: Recurso não encontrado
- **500**: Erro interno do servidor