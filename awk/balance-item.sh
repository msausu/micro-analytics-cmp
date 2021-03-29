#! /usr/bin/env bash

USE_SALDO=${1:-1}
ITEM=${2}

SLD=$(awk -F, "\$2 ~ /${ITEM}/" saldo.csv | head -n1)

if [ ${USE_SALDO} -eq 1 ]; then
    QTD=$(echo "${SLD}" | cut -d, -f4); [ ${QTD} != "" ] || QTD=0
    VLR=$(echo "${SLD}" | cut -d, -f5); [ ${VLR} != "" ] || VLR=0
else
    QTD=0
    VLR=0
fi

awk -F ',' "\$2 ~ /${ITEM}/" mov.csv                 \
    | sort -t ',' -n -k 1,1n                         \
    | awk -F ',' -v quantidade=${QTD} -v valor=${VLR} -f balance-item.awk
