
## `shell/awk`

1. `unoconv` para conversão de xlsx para csv
2. `awk`, `sort`, `bash` para o script que gera o resultado

## Lista de arquivos

1. Entrada

- `MovtoITEM.xlsx`: planilha de movimento (entrada de dados)
- `SaldoITEM.xlsx`: planilha de saldo (entrada de dados)

2. Apoio

- `balance-item.awk`: script para o processamento das linhas do relatório 
- `balance-item.sh`: script auxiliar combinando scripts e arquivos de dados

3. Saída

- `res.csv`: arquivo CSV resultado do processamento 
