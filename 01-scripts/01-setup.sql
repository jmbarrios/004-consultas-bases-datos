CREATE TABLE almacenes (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    lat REAL,
    lon REAL
);

CREATE TABLE puntos (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    lat REAL,
    lon REAL,
    demanda INTEGER
);

CREATE TABLE distancias (
    origen_id INTEGER,
    destino_id INTEGER,
    distancia_km REAL
);

.mode csv
.import --csv --skip 1 00-data/almacenes.csv almacenes
.import --csv --skip 1 00-data/puntos.csv puntos
.import --csv --skip 1 00-data/distancias.csv distancias