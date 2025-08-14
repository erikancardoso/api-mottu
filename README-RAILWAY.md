# 🚀 Deploy no Railway - Pátio API

## 📋 Pré-requisitos

1. Conta no [Railway](https://railway.app)
2. Conta no [Supabase](https://supabase.com) para o banco PostgreSQL
3. Repositório no GitHub com o código

## 🗄️ Configuração do Banco Supabase

### 1. Criar Projeto no Supabase

1. Acesse [supabase.com](https://supabase.com)
2. Clique em "Start your project"
3. Crie uma nova organização (se necessário)
4. Clique em "New Project"
5. Preencha:
   - **Name**: `patio-api-db`
   - **Database Password**: Crie uma senha forte
   - **Region**: Escolha a mais próxima (ex: South America)
6. Clique em "Create new project"

### 2. Obter Credenciais de Conexão

1. No dashboard do projeto, vá em **Settings** → **Database**
2. Na seção **Connection Info**, copie:
   - **Host**
   - **Database name**
   - **Port**
   - **User**
   - **Password** (a que você criou)

### 3. String de Conexão

A URL de conexão terá o formato:
```
jdbc:postgresql://[HOST]:[PORT]/[DATABASE]?sslmode=require
```

Exemplo:
```
jdbc:postgresql://db.abcdefghijklmnop.supabase.co:5432/postgres?sslmode=require
```

## 🚂 Deploy no Railway

### 1. Conectar Repositório

1. Acesse [railway.app](https://railway.app)
2. Faça login com sua conta GitHub
3. Clique em "New Project"
4. Selecione "Deploy from GitHub repo"
5. Escolha o repositório do seu projeto
6. Selecione a branch `main` ou `master`

### 2. Configurar Variáveis de Ambiente

1. No dashboard do projeto Railway, clique na aba **Variables**
2. Adicione as seguintes variáveis:

```bash
SPRING_PROFILES_ACTIVE=prod
SUPABASE_DB_URL=jdbc:postgresql://[SEU_HOST]:5432/postgres?sslmode=require
SUPABASE_DB_USERNAME=postgres
SUPABASE_DB_PASSWORD=[SUA_SENHA_SUPABASE]
PORT=8080
```

**Exemplo com valores reais:**
```bash
SPRING_PROFILES_ACTIVE=prod
SUPABASE_DB_URL=jdbc:postgresql://db.abcdefghijklmnop.supabase.co:5432/postgres?sslmode=require
SUPABASE_DB_USERNAME=postgres
SUPABASE_DB_PASSWORD=MinhaSenh@Forte123
PORT=8080
```

### 3. Deploy Automático

1. O Railway detectará automaticamente que é um projeto Java/Maven
2. O build será iniciado automaticamente
3. Aguarde o deploy ser concluído (pode levar alguns minutos)
4. Você receberá uma URL pública para sua aplicação

## 🌐 URLs após Deploy

Após o deploy bem-sucedido, você terá:

- **API Base**: `https://[seu-projeto].railway.app/api`
- **Swagger UI**: `https://[seu-projeto].railway.app/swagger-ui/index.html`
- **Frontend**: `https://[seu-projeto].railway.app/`
- **Health Check**: `https://[seu-projeto].railway.app/actuator/health`

## 🧪 Testando o Deploy

### 1. Verificar se a aplicação está rodando
```bash
curl https://[seu-projeto].railway.app/api/patios
```

### 2. Testar endpoints principais
- **GET** `/api/patios` - Listar pátios
- **GET** `/api/motos` - Listar motos
- **POST** `/api/patios` - Criar pátio
- **POST** `/api/motos` - Criar moto

### 3. Popular dados de teste
Use o script PowerShell adaptado para produção:
```powershell
.\popular_dados_simples.ps1 -BaseUrl "https://[seu-projeto].railway.app/api"
```

## 🔧 Configurações Avançadas

### Logs da Aplicação
1. No Railway, vá na aba **Deployments**
2. Clique no deployment ativo
3. Visualize os logs em tempo real

### Redeploy Manual
1. No dashboard, clique em **Deployments**
2. Clique em "Redeploy" no deployment mais recente

### Configurar Domínio Customizado
1. Vá na aba **Settings**
2. Clique em **Domains**
3. Adicione seu domínio personalizado

## 🚨 Troubleshooting

### Erro de Build
- Verifique se o Java 17 está configurado no `pom.xml`
- Confirme que todas as dependências estão corretas

### Erro de Conexão com Banco
- Verifique se as variáveis de ambiente estão corretas
- Confirme se a URL do Supabase está com `?sslmode=require`
- Teste a conexão localmente primeiro

### Aplicação não inicia
- Verifique os logs no Railway
- Confirme se a porta está configurada como `PORT=8080`
- Verifique se o perfil `prod` está ativo

### Timeout na inicialização
- O Railway pode levar alguns minutos para o primeiro deploy
- Verifique se não há erros nos logs

## 💰 Custos

- **Railway**: Plano gratuito com 500 horas/mês
- **Supabase**: Plano gratuito com 500MB de storage
- **Total**: Gratuito para desenvolvimento e testes

## 🔄 CI/CD Automático

O Railway automaticamente:
- Detecta mudanças no repositório GitHub
- Faz rebuild e redeploy automaticamente
- Mantém histórico de deployments
- Permite rollback para versões anteriores

## 📞 Suporte

Para mais informações:
- [Documentação Railway](https://docs.railway.app)
- [Documentação Supabase](https://supabase.com/docs)
- [Spring Boot Railway Guide](https://docs.railway.app/guides/java)

---

**✅ Seu projeto está pronto para deploy no Railway!**

Basta seguir os passos acima e em poucos minutos você terá sua API rodando em produção.