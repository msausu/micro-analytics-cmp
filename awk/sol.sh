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

awk -F ',' -v datecol=3 "${AWK}" MovtoITEM.csv > mov.csv
awk -F ',' -v datecol=2 "${AWK}" SaldoITEM.csv | sort -t ',' -n -k 1,1n > saldo.csv

awk -F ',' '{ item[$2] = 1 } END { for (i in item) print i }' mov.csv \
  | while read ITEM; do
    SLD=$(awk -F, "\$2 ~ /${ITEM}/" saldo.csv | head -n1)
    if [ ${USE_SALDO} -eq 1 ]; then
      QTD=$(echo "${SLD}" | cut -d, -f4); [ ${QTD} != "" ] || QTD=0
      VLR=$(echo "${SLD}" | cut -d, -f5); [ ${VLR} != "" ] || VLR=0
    else
      QTD=0
      VLR=0
    fi
    awk -F ',' "\$2 ~ /${ITEM}/" mov.csv               \
      | sort -t ',' -n -k 1,1n                         \
      | awk -F, -v quantidade=${QTD} -v valor=${VLR} -f balance-item.awk
    done                               \
  | sort -t ',' -k 1,1n -k 2,2         \
  | sed 's/^[^,]\+,//'                 \
  > res.csv

rm -f mov.csv saldo.csv 

# eof
