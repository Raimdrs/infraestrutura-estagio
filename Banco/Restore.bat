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