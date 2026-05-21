#!/bin/bash
# setup.sh - Inicializa la base de datos
set -e

DB="logistic.db"

rm -f "$DB"

sqlite3 "$DB" < 01-scripts/01-setup.sql

echo "Base de datos creada: $DB"