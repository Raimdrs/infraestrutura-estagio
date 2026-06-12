# Atividade Técnica – Estágio Infraestrutura

## Descrição

Este projeto foi desenvolvido como parte do processo seletivo para a vaga de Estágio em Infraestrutura.

O objetivo é demonstrar conhecimentos básicos de administração de banco de dados PostgreSQL, automação de tarefas utilizando scripts PowerShell e monitoramento de serviços.

## Funcionalidades

### Banco de Dados PostgreSQL

* Criação de banco de dados de exemplo.
* Criação de tabela e inserção de dados.
* Geração de backup (dump) do banco.
* Restauração do banco a partir do backup.

### Monitoramento de Serviços

* Verificação do status do Tomcat e jboss.
* Exibição do status da instância.

---

infraestrutura-estagio/
│
├── banco/
│   ├── dump.ps1
│   └── restore.ps1
│
├── servicos/
│   └── jboss.ps1
│
└── README.md

---

# Requisitos

* Windows 10 ou superior
* PostgreSQL instalado
* PowerShell
* Git (opcional para versionamento)

---

# Configuração do Banco

## Criar banco de dados

Execute no PostgreSQL:

```sql
CREATE DATABASE empresa;
```

Conecte-se ao banco criado e execute:

```sql
CREATE TABLE funcionarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    cargo VARCHAR(100)
);

INSERT INTO funcionarios(nome,cargo)
VALUES
('João','Analista'),
('Maria','Desenvolvedora');
```

---

# Dump do Banco

O script `dump.bat` realiza o backup do banco de dados.

Exemplo:

```powershell
@echo off
echo Iniciando o backup do banco de dados...

set PGPASSWORD=1234

pg_dump -U postgres -h localhost -d empresa > backup.sql

if %ERRORLEVEL% EQU 0 (
    echo Backup realizado com sucesso!
) else (
    echo Falha ao realizar o backup. Verifique se o banco "empresa" existe e se as credenciais estao corretas.
)

set PGPASSWORD=
```

Execução:

Basta dar executar o arquivo Dump.bat

Resultado:

```text
backup.sql
```

---

# Restore do Banco

O script `restore.bat` restaura o banco utilizando o arquivo de backup.

Exemplo:

```powershell
@echo off
echo Iniciando a restauracao do banco de dados...

set PGPASSWORD=1234

psql -U postgres -h localhost -d empresa -f backup.sql

if %ERRORLEVEL% EQU 0 (
    echo Restauracao concluida com sucesso!
) else (
    echo Falha ao realizar a restauracao. Verifique se o banco de destino existe.
)

set PGPASSWORD=
```

Execução:

Basta dar executar o arquivo Dump.bat

---

# Verificação do Tomcat

O script `tomcat.ps1` verifica se existe uma instância do Tomcat instalada e informa seu status.

Exemplo:

```powershell
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

pause
```

Execução:

```powershell
.\tomcat.ps1
```
# Verificação do jboss

O script `jboss.ps1` verifica se existe uma instância do Tomcat instalada e informa seu status.

Exemplo:

```powershell
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

pause
```

Execução:

```powershell
.\jboss.ps1
```

---

# Tecnologias Utilizadas

* PostgreSQL
* PowerShell
* Git
* GitHub
* Windows

---

# Autor

Raí de Medeiros

Aluno do Bacharelado em Tecnologia da Informação (BTI) – UFRN.
