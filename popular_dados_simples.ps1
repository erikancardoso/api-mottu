# Script para popular o banco de dados via API REST
# Utiliza Invoke-RestMethod nativo do PowerShell
# 
# Uso:
#   .\popular_dados_simples.ps1                                    # Para localhost
#   .\popular_dados_simples.ps1 -BaseUrl "https://seu-projeto.railway.app/api"  # Para produção

param(
    [string]$BaseUrl = "http://localhost:8090/api",
    [switch]$Limpar
)

# Função para fazer requisições HTTP
function Invoke-ApiCall {
    param(
        [string]$Method,
        [string]$Url,
        [object]$Body = $null
    )
    
    try {
        $headers = @{
            "Content-Type" = "application/json"
        }
        
        if ($Body) {
            $jsonBody = $Body | ConvertTo-Json -Depth 10
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers -Body $jsonBody
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers
        }
        
        return $response
    }
    catch {
        Write-Host "Erro na requisição $Method $Url : $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

Write-Host "=== POPULANDO BANCO DE DADOS ===" -ForegroundColor Cyan
Write-Host "URL Base: $BaseUrl" -ForegroundColor Yellow

# Limpar dados se solicitado
if ($Limpar) {
    Write-Host "Limpando dados existentes..." -ForegroundColor Yellow
    
    # Buscar e deletar todas as motos
    $motos = Invoke-ApiCall -Method "GET" -Url "$BaseUrl/motos"
    if ($motos) {
        foreach ($moto in $motos) {
            Invoke-ApiCall -Method "DELETE" -Url "$BaseUrl/motos/$($moto.id)"
        }
        Write-Host "Motos removidas: $($motos.Count)" -ForegroundColor Green
    }
    
    # Buscar e deletar todos os pátios
    $patios = Invoke-ApiCall -Method "GET" -Url "$BaseUrl/patios"
    if ($patios) {
        foreach ($patio in $patios) {
            Invoke-ApiCall -Method "DELETE" -Url "$BaseUrl/patios/$($patio.id)"
        }
        Write-Host "Pátios removidos: $($patios.Count)" -ForegroundColor Green
    }
}

# Criar pátios
Write-Host "Criando pátios..." -ForegroundColor Yellow

$patiosData = @(
    @{ nome = "Pátio Central"; endereco = "Rua das Flores, 123 - Centro" },
    @{ nome = "Pátio Norte"; endereco = "Av. Paulista, 456 - Bela Vista" },
    @{ nome = "Pátio Sul"; endereco = "Rua Augusta, 789 - Consolação" },
    @{ nome = "Pátio Leste"; endereco = "Av. Faria Lima, 321 - Itaim Bibi" },
    @{ nome = "Pátio Oeste"; endereco = "Rua Oscar Freire, 654 - Jardins" }
)

$patiosCriados = @()
foreach ($patioData in $patiosData) {
    $patio = Invoke-ApiCall -Method "POST" -Url "$BaseUrl/patios" -Body $patioData
    if ($patio) {
        $patiosCriados += $patio
        Write-Host "Pátio criado: $($patio.nome) (ID: $($patio.id))" -ForegroundColor Green
    }
}

# Criar motos
Write-Host "Criando motos..." -ForegroundColor Yellow

$motosData = @(
    @{ placa = "ABC-1234"; status = "DISPONIVEL" },
    @{ placa = "DEF-5678"; status = "DISPONIVEL" },
    @{ placa = "GHI-9012"; status = "EM_USO" },
    @{ placa = "JKL-3456"; status = "DISPONIVEL" },
    @{ placa = "MNO-7890"; status = "MANUTENCAO" },
    @{ placa = "PQR-1357"; status = "DISPONIVEL" },
    @{ placa = "STU-2468"; status = "EM_USO" },
    @{ placa = "VWX-9753"; status = "DISPONIVEL" },
    @{ placa = "YZA-8642"; status = "DISPONIVEL" },
    @{ placa = "BCD-1975"; status = "MANUTENCAO" }
)

$motosCriadas = @()
foreach ($i in 0..($motosData.Count - 1)) {
    $motoData = $motosData[$i]
    
    # Associar moto a um pátio (distribuir entre os pátios criados)
    if ($patiosCriados.Count -gt 0) {
        $patioIndex = $i % $patiosCriados.Count
        $motoData.patioId = $patiosCriados[$patioIndex].id
    }
    
    $moto = Invoke-ApiCall -Method "POST" -Url "$BaseUrl/motos" -Body $motoData
    if ($moto) {
        $motosCriadas += $moto
        $patioNome = if ($moto.patio) { $moto.patio.nome } else { "Sem pátio" }
        Write-Host "Moto criada: $($moto.placa) - Status: $($moto.status) - Pátio: $patioNome" -ForegroundColor Green
    }
}

# Resumo final
Write-Host "" 
Write-Host "=== RESUMO FINAL ===" -ForegroundColor Cyan

$patiosFinais = Invoke-ApiCall -Method "GET" -Url "$BaseUrl/patios"
$motosFinais = Invoke-ApiCall -Method "GET" -Url "$BaseUrl/motos"

if ($patiosFinais) {
    Write-Host "Total de pátios: $($patiosFinais.Count)" -ForegroundColor White
}
if ($motosFinais) {
    Write-Host "Total de motos: $($motosFinais.Count)" -ForegroundColor White
    
    # Estatísticas por status
    $statusCount = @{}
    foreach ($moto in $motosFinais) {
        $status = $moto.status
        if ($statusCount.ContainsKey($status)) {
            $statusCount[$status]++
        } else {
            $statusCount[$status] = 1
        }
    }
    
    Write-Host "Motos por status:" -ForegroundColor White
    foreach ($status in $statusCount.Keys) {
        Write-Host "  - $status : $($statusCount[$status])" -ForegroundColor Gray
    }
}

Write-Host "" 
Write-Host "Banco de dados populado com sucesso!" -ForegroundColor Green
Write-Host "Acesse o frontend: $($BaseUrl.Replace('/api', ''))" -ForegroundColor Cyan
Write-Host "Acesse o Swagger: $($BaseUrl.Replace('/api', ''))/swagger-ui/index.html" -ForegroundColor Cyan