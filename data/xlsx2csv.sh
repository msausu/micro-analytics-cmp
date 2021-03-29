#! /usr/bin/env bash

DIR=$(dirname ${0})
DESTDIR=${1:-${DIR}}

for XLSX in ${DIR}/*.xlsx; do
    T=$(basename ${XLSX} .xlsx)
    unoconv -f csv -o ${DESTDIR}/${T}.csv ${XLSX}
done

# eof
