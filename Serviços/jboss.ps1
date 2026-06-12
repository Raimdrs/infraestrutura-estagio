Write-Host "===== VERIFICANDO SERVIÇO JBOSS ====="

# Arquivo temporário específico para o JBoss
$LockFile = "$env:TEMP\jboss_parado.lock"

# Busca o serviço. Atenção: no Windows, o JBoss às vezes é instalado com o nome "WildFly*"
$jboss = Get-Service -Name JBoss* -ErrorAction SilentlyContinue

if ($jboss) {

    if ($jboss.Status -eq "Running") {

        Write-Host "JBoss está rodando"
        
        # Se está rodando, apaga o cronômetro (caso exista)
        if (Test-Path $LockFile) { Remove-Item $LockFile }

    } else {

        Write-Host "JBoss parado"

        # Verifica se já tínhamos marcado a hora que ele parou
        if (Test-Path $LockFile) {
            $arquivo = Get-Item $LockFile
            $tempoParado = (Get-Date) - $arquivo.CreationTime
            
            Write-Host "Tempo parado: $([math]::Round($tempoParado.TotalSeconds)) segundos"
            
            # Se passou de 60 segundos, tenta iniciar o serviço
            if ($tempoParado.TotalSeconds -ge 60) {
                Write-Host "Iniciando o JBoss automaticamente..."
                Start-Service -Name $jboss.Name
                Remove-Item $LockFile
            }
        } else {
            # Se o arquivo não existe, cria agora para marcar a hora da queda
            New-Item -Path $LockFile -ItemType File | Out-Null
            Write-Host "Iniciando contagem de tempo parado..."
        }
    }

} else {

    Write-Host "JBoss não encontrado"

}

Write-Host "====================================="

# Pausa a tela no final para você conseguir ler ao rodar o .bat ou direto no PowerShell
pause