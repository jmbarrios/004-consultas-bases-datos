# Tarea práctica: Optimización de rutas de reparto con SQLite

## Contexto 

Una empresa de logística tiene tres centros de distribución (almacenes) y diez puntos de entrega en la Ciudad de México. Se conocen las coordenadas de cada lugar y la demanda de cada punto. Además, existe una tabla con las distancias por carretera entre almacenes y puntos, así como entre algunos pares de puntos.

## Dataset  

Las tablas son:

- `almacenes(id, nombre, lat, lon)`
- `puntos(id, nombre, lat, lon, demanda)`
- `distancias(origen_id, destino_id, distancia_km)`  
  `origen_id` y `destino_id` pueden referirse a un `almacen` o un `punto`. La tabla contiene **todos** los pares almacén‑punto (origen = almacén, destino = punto) y algunas conexiones entre puntos (**en ambos sentidos**).


Los datos están en la carpeta `00-data/`. No los modifiques.

## Formato de entrega

Completa cada archivo SQL en la carpeta `02-consultas/`:
- `01-query.sql` a `04-query.sql` deben contener **únicamente** la consulta SQL correspondiente.  
- Las columnas deben aparecer en el orden pedido y con los nombres indicados.  
- No incluyas punto y coma final (opcional, pero se acepta).
- Manejo de duplicados. Cuando hay múltip.les registros de distancia para el mismo par, usar el primero que aparece en la tabla.
  
Cada consulta se evaluará automáticamente ejecutando:
```bash
sqlite3 -separator '|' logistic.db < 02-consultas/XX-query.sql
```
y comparando la salida con la esperada.

## Actividades

### 1. Punto más alejado de cada almacén

**Objetivo:** Identificar el punto de entrega más distante para cada centro de distribución.

**Descripción detallada:**
Para cada uno de los tres almacenes (Centro, Norte, Sur), encuentra el punto de entrega que tiene la **mayor distancia** desde ese almacén. Esto es útil para identificar rutas más largas o puntos problemáticos de cobertura.

**Requisitos:**
- Considerar solo la distancia más corta si existen múltiples registros para el mismo par almacén-punto
- Mostrar la distancia en kilómetros
- Ordenar por ID del almacén (de menor a mayor)

**Columnas de salida:** 
- `almacen_id`: Identificador del almacén
- `nombre_almacen`: Nombre del almacén
- `punto_id`: Identificador del punto de entrega
- `nombre_punto`: Nombre del punto de entrega
- `distancia`: Distancia en kilómetros (una fila por almacén)

### 2. Matriz de distancias almacenes-puntos

**Objetivo:** Crear una tabla completa de distancias entre todos los almacenes y todos los puntos de entrega.

**Descripción detallada:**
Genera una matriz (tabla) que muestre todas las rutas directas disponibles desde cada almacén hacia cada punto de entrega. Si existen múltiples registros de distancia para la misma ruta, usar la primera que aparece en la base de datos.

**Requisitos:**
- Una fila por combinación almacén-punto
- Incluir solo puntos de entrega (IDs 1-10), no almacenes como destino
- Si hay múltiples distancias registradas para el mismo par, tomar la primera
- Ordenar primero por almacén, luego por punto dentro de cada almacén

**Columnas de salida:**
- `nombre_almacen`: Nombre del almacén (origen)
- `nombre_punto`: Nombre del punto de entrega (destino)
- `distancia_km`: Distancia en kilómetros

**Total esperado:** 30 filas (3 almacenes × 10 puntos)

### 3. Centro de distribución óptimo

**Objetivo:** Determinar cuál almacén es el más eficiente para servir a todos los puntos de entrega.

**Descripción detallada:**
Calcula la suma total de distancias desde cada almacén hacia todos los puntos de entrega. El almacén con la **suma más pequeña** es el más eficiente (minimiza el costo logístico total). Si hay empate, mostrar el almacén con menor ID.

**Requisitos:**
- Sumar todas las distancias desde cada almacén hacia sus puntos de entrega
- Usar la primera distancia registrada si hay múltiples para el mismo par
- Mostrar solo el almacén ganador (una sola fila)
- En caso de empate, priorizar el de menor ID

**Columnas de salida:**
- `almacen_id`: Identificador del almacén óptimo
- `nombre`: Nombre del almacén óptimo
- `suma_distancias`: Suma total de distancias en kilómetros

### 4. Ruta de reparto simple

**Objetivo:** Diseñar una ruta básica de entrega optimizada por distancia.

**Descripción detallada:**
Para el almacén Centro (ID = 1), crear una **ruta optimizada** que visite todos los puntos ordenados por distancia creciente. Asignar a cada punto un número de orden secuencial (1º, 2º, 3º, etc.), comenzando por el más cercano y terminando por el más lejano.

**Requisitos:**
- Considerar solo el almacén con ID = 1
- Ordenar puntos de menor a mayor distancia
- Usar la primera distancia registrada si hay múltiples para el mismo par
- Asignar números secuenciales comenzando en 1
- Mostrar una fila por punto de entrega

**Columnas de salida:**
- `punto_id`: Identificador del punto
- `nombre_punto`: Nombre del punto de entrega
- `distancia`: Distancia desde el almacén en kilómetros
- `orden`: Posición en la ruta (1, 2, 3, ..., 10)

**Nota:** Esta es una solución heurística simple (greedy nearest-neighbor). 
