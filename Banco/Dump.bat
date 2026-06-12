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