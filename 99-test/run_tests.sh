#!/bin/bash
# run_tests.sh - Ejecuta las pruebas de las consultas SQL

set -e

DB="logistic.db"

# Limpieza
cleanup() {
    rm -f "$DB" output_query_*.txt
}
trap cleanup EXIT

sqlite3 "$DB" < 01-scripts/01-setup.sql

if [ $# -eq 1 ]; then
    queries=("$1")
else
    queries=(1 2 3 4)
fi

for i in "${queries[@]}"; do
    out="output_query_0${i}.txt"
    expected="99-test/expected/0${i}-result.txt"
    
    sqlite3 -separator '|' "$DB" < "02-consultas/0${i}-query.sql" > "$out" 2>/dev/null
    
    if diff -q "$out" "$expected" >/dev/null 2>&1; then
        echo "${i}:APROBADA"
    else
        echo "${i}:FALLIDA"
    fi
done