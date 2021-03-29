# Análise de dados

Comparação de 3 abordagens para produzir um relatório: `shell/awk`, `julia`, `sql` (`sqlite`)

## Apresentação do relatório a ser desenvolvido:

O caso a ser desenvolvido é de movimentação de estoque ao longo de um ano. O resultado
esperado é uma base de dados pronta a ser publicada como análise em tabelas e gráficos.
Os dados disponibilizados estão em 2 arquivos no formato de planilha eletrônica contendo
toda a movimentação de itens ao longo de 1(um) ano e os saldos inicial e final de cada item
durante o período correspondente.

## Resultado esperado

1. Uma base de dados (pode ser planilha ou CSV) contendo a movimentação DIÁRIA de cada ITEM, da seguinte forma:

a. Item: formato texto
b. Data do lançamento: formato dd/mm/aaaa
c. Lançamentos de ENTRADA: quantidade, formato decimal
d. Lançamentos de ENTRADA: valor, formato decimal
e. Lançamentos de SAIDA: quantidade, formato decimal
f. Lançamentos de SAIDA: valor, formato decimal
g. Saldo Inicial em quantidade, formato decimal
h. Saldo Inicial em valor, formato decimal
i. Saldo Final em quantidade, formato decimal
j. Saldo Final em valor, formato decimal

## Detalhes

a) Podem haver vários lançamentos, seja de entrada ou saída, para cada item no mesmo
dia. Importante que a base final é diária. Ou seja, é necessário fazer o devido
agrupamento diário para cada item, somando todas as ocorrências de entrada e/ou
saída correspondentes.
b) A formula geral de saldos é: `saldo final = saldo inicial + entrada – saída`
c) No arquivo de saldos, as datas inicial e final definem o período total de movimentação

Estrutura dos dados de origem

Arquivo SaldoITEM.xlsx:
a) Item: código do item de produto
b) data_inicio: data base do saldo inicial do item
c) qtd_inicio: saldo inicial, em quantidade
d) valor_inicio: saldo inicial, em valor
e) data_final: data base do saldo final do item
f) qtd_final: saldo final, em quantidade
g) valor_final: saldo final, em valor

Arquivo MovtoITEM.xlsx:
a) item: código do item de produto
b) tipo_movimento:
a. “Ent” significa movimento de entrada do item no estoque
b. “Sai” significa movimento de saída do item no estoque
c) data_lancamento: data em que ocorreu o tipo_movimento para o item
d) quantidade: quantidade do tipo_movimento do item
e) valor: valor do tipo_movimento do item

