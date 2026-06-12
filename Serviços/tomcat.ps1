Write-Host "===== VERIFICANDO SERVIÇOS ====="

# Arquivo temporário para servir como "cronômetro"
$LockFile = "$env:TEMP\tomcat_parado.lock"

$tomcat = Get-Service -Name Tomcat* -ErrorAction SilentlyContinue

if ($tomcat) {

    if ($tomcat.Status -eq "Running") {

        Write-Host "Tomcat está rodando"
        
        # Se está rodando, apaga o cronômetro (caso exista)
        if (Test-Path $LockFile) { Remove-Item $LockFile }

    } else {

        Write-Host "Tomcat parado"

        # Verifica se já tínhamos marcado a hora que ele parou
        if (Test-Path $LockFile) {
            $arquivo = Get-Item $LockFile
            $tempoParado = (Get-Date) - $arquivo.CreationTime
            
            Write-Host "Tempo parado: $([math]::Round($tempoParado.TotalSeconds)) segundos"
            
            # Se passou de 60 segundos, tenta iniciar o serviço
            if ($tempoParado.TotalSeconds -ge 60) {
                Write-Host "Iniciando o Tomcat automaticamente..."
                Start-Service -Name $tomcat.Name
                Remove-Item $LockFile
            }
        } else {
            # Se o arquivo não existe, cria agora para marcar a hora da queda
            New-Item -Path $LockFile -ItemType File | Out-Null
            Write-Host "Iniciando contagem de tempo parado..."
        }
    }

} else {

    Write-Host "Tomcat não encontrado"

}

Write-Host "================================"

# Pausa a tela no final para você conseguir ler ao rodar o .bat
pause