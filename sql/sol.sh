#! /bin/bash

DATEFORMAT='
  function dateformat(s) {
    split(s, d, "/")
    return d[3] "-" (length(d[1]) == 1 ? "0" : "") d[1] "-" (length(d[2]) == 1 ? "0" : "") d[2]
  }
'

FIX_MovtoITEM="
  ${DATEFORMAT}
  NR == 1 {
    print \$0
  }
  NR > 1 {
    print \$1 \",\" \$2 \",\" dateformat(\$3) \",\" \$4 \",\" \$5
  }
"

FIX_SaldoITEM="
  ${DATEFORMAT}
  NR == 1 {
    print \$0
  }
  NR > 1 {
    print \$1 \",\" dateformat(\$2) \",\" \$3 \",\" \$4 \",\" dateformat(\$5) \",\" \$6 \",\" \$7
  }
"

[ -r MovtoITEM.csv -a -r SaldoITEM.csv ] || {
  bash ../data/xlsx2csv.sh $(pwd)
  for F in MovtoITEM SaldoITEM
    do
      FIX="FIX_${F}"
      eval awk -F ',' \"\$${FIX}\" ${F}.csv > .tmpf
      mv .tmpf ${F}.csv 
    done
}

sqlite3 '' -csv < sol.sql 2> /dev/null > res.csv

# eof
