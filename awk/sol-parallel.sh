#! /usr/bin/env bash

USE_SALDO=${1:-1}

[ -r MovtoITEM.csv -a -r SaldoITEM.csv ] || bash ../data/xlsx2csv.sh $(pwd)

AWK='function dateformat(s) {
  split(s, d, "/")
  return d[3] (length(d[1]) == 1 ? "0" : "") d[1] (length(d[2]) == 1 ? "0" : "") d[2]
}
BEGIN {
  DF = datecol
}
NR > 1 {
  print dateformat($DF) "," $0
}
'

{
  awk -F ',' -v datecol=2 "${AWK}" SaldoITEM.csv | sort -t ',' -n -k 1,1n > saldo.csv &
  P1=${!}
  awk -F ',' -v datecol=3 "${AWK}" MovtoITEM.csv > mov.csv &
  P2=${!}
  wait -f ${P1} ${P2}
  }                                                                        \
  && awk -F ',' '{ item[$2] = 1 } END { for (i in item) print i }' mov.csv \
  | parallel -q bash balance-item.sh ${USE_SALDO} {}                       \
  | sort -t ',' -k 1,1n -k 2,2                                             \
  | sed 's/^[^,]\+,//'                                                     \
  > res-parallel.csv

rm -f mov.csv saldo.csv 

# eof
