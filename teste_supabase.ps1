# Script para testar conexão com Supabase
# Execute este script após configurar as variáveis de ambiente

Write-Host "🚀 Testando conexão com Supabase..." -ForegroundColor Green

# Verificar se as variáveis de ambiente estão definidas
if (-not $env:SUPABASE_DB_URL) {
    Write-Host "❌ SUPABASE_DB_URL não está definida" -ForegroundColor Red
    Write-Host "Configure as variáveis de ambiente primeiro:" -ForegroundColor Yellow
    Write-Host '$env:SUPABASE_DB_URL="jdbc:postgresql://[HOST]:5432/postgres?sslmode=require"' -ForegroundColor Cyan
    Write-Host '$env:SUPABASE_DB_USERNAME="postgres"' -ForegroundColor Cyan
    Write-Host '$env:SUPABASE_DB_PASSWORD="[SUA_SENHA]"' -ForegroundColor Cyan
    exit 1
}

if (-not $env:SUPABASE_DB_USERNAME) {
    Write-Host "❌ SUPABASE_DB_USERNAME não está definida" -ForegroundColor Red
    exit 1
}

if (-not $env:SUPABASE_DB_PASSWORD) {
    Write-Host "❌ SUPABASE_DB_PASSWORD não está definida" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Variáveis de ambiente configuradas" -ForegroundColor Green
Write-Host "📊 URL: $env:SUPABASE_DB_URL" -ForegroundColor Cyan
Write-Host "👤 Username: $env:SUPABASE_DB_USERNAME" -ForegroundColor Cyan

# Definir JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Java\jdk-24"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Host "☕ Java configurado: $env:JAVA_HOME" -ForegroundColor Green

# Executar aplicação com perfil de produção
Write-Host "🔄 Iniciando aplicação com Supabase..." -ForegroundColor Yellow

try {
    .\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=prod
}
catch {
    Write-Host "❌ Erro ao iniciar aplicação: $_" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Aplicação iniciada com sucesso!" -ForegroundColor Green
Write-Host "🌐 Acesse: http://localhost:8080" -ForegroundColor Cyan
Write-Host "📚 Swagger: http://localhost:8080/swagger-ui/index.html" -ForegroundColor Cyan