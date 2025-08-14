# Script para popular o banco de dados via API REST
# Pode ser usado tanto para H2 local quanto para Supabase em produção

param(
    [string]$BaseUrl = "http://localhost:8090/api",
    [switch]$Limpar = $false
)

Write-Host "🚀 Populando banco de dados via API REST..." -ForegroundColor Green
Write-Host "📍 URL Base: $BaseUrl" -ForegroundColor Cyan
Write-Host ""

# Função para fazer requisições HTTP
function Invoke-ApiRequest {
    param(
        [string]$Method,
        [string]$Url,
        [object]$Body = $null
    )
    
    try {
        $headers = @{
            'Content-Type' = 'application/json'
            'Accept' = 'application/json'
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
        Write-Host "❌ Erro na requisição $Method $Url" -ForegroundColor Red
        Write-Host "   Detalhes: $($_.Exception.Message)" -ForegroundColor Yellow
        return $null
    }
}

# Limpar dados existentes se solicitado
if ($Limpar) {
    Write-Host "🧹 Limpando dados existentes..." -ForegroundColor Yellow
    
    # Buscar e excluir todas as motos
    $motos = Invoke-ApiRequest -Method "GET" -Url "$BaseUrl/motos"
    if ($motos -and $motos.content) {
        foreach ($moto in $motos.content) {
            $null = Invoke-ApiRequest -Method "DELETE" -Url "$BaseUrl/motos/$($moto.id)"
            Write-Host "   🗑️ Moto $($moto.modelo) removida" -ForegroundColor Gray
        }
    }
    
    # Buscar e excluir todos os pátios
    $patios = Invoke-ApiRequest -Method "GET" -Url "$BaseUrl/patios"
    if ($patios -and $patios.content) {
        foreach ($patio in $patios.content) {
            $null = Invoke-ApiRequest -Method "DELETE" -Url "$BaseUrl/patios/$($patio.id)"
            Write-Host "   🗑️ Pátio $($patio.nome) removido" -ForegroundColor Gray
        }
    }
    
    Write-Host "✅ Limpeza concluída!" -ForegroundColor Green
    Write-Host ""
}

# Dados dos pátios
$patiosData = @(
    @{ nome = "Pátio Central"; endereco = "Rua das Flores, 123 - Centro, São Paulo - SP" },
    @{ nome = "Pátio Norte"; endereco = "Avenida Paulista, 456 - Bela Vista, São Paulo - SP" },
    @{ nome = "Pátio Sul"; endereco = "Rua Augusta, 789 - Consolação, São Paulo - SP" },
    @{ nome = "Pátio Leste"; endereco = "Rua Oscar Freire, 321 - Jardins, São Paulo - SP" },
    @{ nome = "Pátio Oeste"; endereco = "Avenida Faria Lima, 654 - Itaim Bibi, São Paulo - SP" },
    @{ nome = "Pátio Express"; endereco = "Rua da Consolação, 987 - República, São Paulo - SP" }
)

# Criar pátios
Write-Host "🏢 Criando pátios..." -ForegroundColor Blue
$patioIds = @()

foreach ($patioData in $patiosData) {
    $patio = Invoke-ApiRequest -Method "POST" -Url "$BaseUrl/patios" -Body $patioData
    if ($patio) {
        $patioIds += $patio.id
        Write-Host "   ✅ Pátio '$($patio.nome)' criado (ID: $($patio.id))" -ForegroundColor Green
    }
}

Write-Host "📊 Total de pátios criados: $($patioIds.Count)" -ForegroundColor Cyan
Write-Host ""

# Dados das motos
$motosData = @(
    # Motos do Pátio Central
    @{ modelo = "Honda CG 160"; placa = "ABC-1234"; ano = 2023; status = "DISPONIVEL"; patioIndex = 0 },
    @{ modelo = "Yamaha Factor 125"; placa = "DEF-5678"; ano = 2022; status = "DISPONIVEL"; patioIndex = 0 },
    @{ modelo = "Honda Biz 125"; placa = "GHI-9012"; ano = 2023; status = "ALUGADA"; patioIndex = 0 },
    @{ modelo = "Suzuki Burgman 125"; placa = "JKL-3456"; ano = 2021; status = "EM_MANUTENCAO"; patioIndex = 0 },
    
    # Motos do Pátio Norte
    @{ modelo = "Honda PCX 150"; placa = "MNO-7890"; ano = 2023; status = "DISPONIVEL"; patioIndex = 1 },
    @{ modelo = "Yamaha NMAX 160"; placa = "PQR-1234"; ano = 2022; status = "DISPONIVEL"; patioIndex = 1 },
    @{ modelo = "Honda ADV 150"; placa = "STU-5678"; ano = 2023; status = "ALUGADA"; patioIndex = 1 },
    @{ modelo = "Suzuki GSX-S 150"; placa = "VWX-9012"; ano = 2021; status = "DISPONIVEL"; patioIndex = 1 },
    
    # Motos do Pátio Sul
    @{ modelo = "Honda CB 600F"; placa = "YZA-3456"; ano = 2022; status = "DISPONIVEL"; patioIndex = 2 },
    @{ modelo = "Yamaha MT-03"; placa = "BCD-7890"; ano = 2023; status = "EM_MANUTENCAO"; patioIndex = 2 },
    @{ modelo = "Kawasaki Ninja 300"; placa = "EFG-1234"; ano = 2021; status = "DISPONIVEL"; patioIndex = 2 },
    @{ modelo = "Honda CB 250F"; placa = "HIJ-5678"; ano = 2022; status = "ALUGADA"; patioIndex = 2 },
    
    # Motos do Pátio Leste
    @{ modelo = "BMW G 310 R"; placa = "KLM-9012"; ano = 2023; status = "DISPONIVEL"; patioIndex = 3 },
    @{ modelo = "KTM Duke 200"; placa = "NOP-3456"; ano = 2022; status = "DISPONIVEL"; patioIndex = 3 },
    @{ modelo = "Honda CB 1000R"; placa = "QRS-7890"; ano = 2021; status = "EM_MANUTENCAO"; patioIndex = 3 },
    
    # Motos do Pátio Oeste
    @{ modelo = "Harley Davidson Street 750"; placa = "TUV-1234"; ano = 2022; status = "DISPONIVEL"; patioIndex = 4 },
    @{ modelo = "Triumph Street Triple"; placa = "WXY-5678"; ano = 2023; status = "ALUGADA"; patioIndex = 4 },
    @{ modelo = "Ducati Monster 797"; placa = "ZAB-9012"; ano = 2021; status = "DISPONIVEL"; patioIndex = 4 },
    
    # Motos do Pátio Express
    @{ modelo = "Honda CG 160 Titan"; placa = "CDE-3456"; ano = 2023; status = "DISPONIVEL"; patioIndex = 5 },
    @{ modelo = "Yamaha Crosser 150"; placa = "FGH-7890"; ano = 2022; status = "DISPONIVEL"; patioIndex = 5 },
    @{ modelo = "Honda Bros 160"; placa = "IJK-1234"; ano = 2023; status = "EM_MANUTENCAO"; patioIndex = 5 },
    @{ modelo = "Suzuki Intruder 150"; placa = "LMN-5678"; ano = 2021; status = "DISPONIVEL"; patioIndex = 5 }
)

# Criar motos
Write-Host "🏍️ Criando motos..." -ForegroundColor Blue
$motosCreated = 0

foreach ($motoData in $motosData) {
    if ($motoData.patioIndex -lt $patioIds.Count) {
        $motoRequest = @{
            modelo = $motoData.modelo
            placa = $motoData.placa
            ano = $motoData.ano
            status = $motoData.status
            patioId = $patioIds[$motoData.patioIndex]
        }
        
        $moto = Invoke-ApiRequest -Method "POST" -Url "$BaseUrl/motos" -Body $motoRequest
        if ($moto) {
            $motosCreated++
            Write-Host "   ✅ Moto '$($moto.modelo)' criada no pátio ID $($moto.patioId)" -ForegroundColor Green
        }
    }
}

Write-Host "📊 Total de motos criadas: $motosCreated" -ForegroundColor Cyan
Write-Host ""

# Resumo final
Write-Host "📈 RESUMO FINAL" -ForegroundColor Magenta
Write-Host "===============" -ForegroundColor Magenta

# Buscar estatísticas finais
$patiosFinais = Invoke-ApiRequest -Method "GET" -Url "$BaseUrl/patios"
$motosFinais = Invoke-ApiRequest -Method "GET" -Url "$BaseUrl/motos"

if ($patiosFinais -and $motosFinais) {
    Write-Host "🏢 Pátios no banco: $($patiosFinais.totalElements)" -ForegroundColor Green
    Write-Host "🏍️ Motos no banco: $($motosFinais.totalElements)" -ForegroundColor Green
    
    # Estatísticas por status
    $disponivel = ($motosFinais.content | Where-Object { $_.status -eq "DISPONIVEL" }).Count
    $alugada = ($motosFinais.content | Where-Object { $_.status -eq "ALUGADA" }).Count
    $manutencao = ($motosFinais.content | Where-Object { $_.status -eq "EM_MANUTENCAO" }).Count
    
    Write-Host "📊 Status das motos:" -ForegroundColor Cyan
    Write-Host "   🟢 Disponíveis: $disponivel" -ForegroundColor Green
    Write-Host "   🔴 Alugadas: $alugada" -ForegroundColor Red
    Write-Host "   🟡 Em manutenção: $manutencao" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Banco de dados populado com sucesso!" -ForegroundColor Green
Write-Host "🌐 Acesse o frontend: $($BaseUrl.Replace('/api', ''))" -ForegroundColor Cyan
Write-Host "📚 Acesse o Swagger: $($BaseUrl.Replace('/api', ''))/swagger-ui/index.html" -ForegroundColor Cyan

# Exemplos de uso
Write-Host ""
Write-Host "EXEMPLOS DE USO:" -ForegroundColor Yellow
Write-Host "   # Popular dados locais (H2):" -ForegroundColor Gray
Write-Host "   .\popular_dados.ps1" -ForegroundColor White
Write-Host ""
Write-Host "   # Popular dados em produção:" -ForegroundColor Gray
Write-Host "   .\popular_dados.ps1 -BaseUrl `"https://seu-app.railway.app/api`"" -ForegroundColor White
Write-Host ""
Write-Host "   # Limpar e repopular:" -ForegroundColor Gray
Write-Host "   .\popular_dados.ps1 -Limpar" -ForegroundColor White