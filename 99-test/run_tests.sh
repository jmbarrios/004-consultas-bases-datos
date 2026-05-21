#!/bin/bash
set -e

DB="logistic.db"
PASS_MSG="SUCCESS"
FAIL_MSG="FAIL"

# Si se pasa un número como argumento, solo se evalúa esa consulta
if [ $# -eq 1 ]; then
    queries=("$1")
else
    queries=(1 2 3 4 5 6)
fi

# Recrear la base de datos desde cero
rm -f "$DB"
sqlite3 "$DB" < 01-scripts/01-setup.sql

for i in "${queries[@]}"; do
    out="output_query_0${i}.txt"
    
    # Ejecutar la consulta del estudiante
    if sqlite3 -separator '|' "$DB" < 02-consultas/0${i}-query.sql > "$out" 2>/dev/null; then
        if diff -q "$out" 99-test/expected/0${i}-result.txt >/dev/null 2>&1; then
            echo "${i}:${PASS_MSG}"
        else
            echo "${i}:${FAIL_MSG}"
            # Mostrar diferencias para depuración (opcional, no afecta el autograding)
            echo "--- Diferencias consulta $i ---"
            diff "$out" 99-test/expected/0${i}-result.txt || true
            echo "-------------------------------"
        fi
    else
        echo "${i}:${FAIL_MSG}"
        echo "Error al ejecutar la consulta $i"
    fi
done