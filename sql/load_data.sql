-- Creacion de tabla de staging, para almacenar la informacion del CSV
-- y luego hacer queries sobre ella para insertar a las demas tablas.
CREATE TABLE IF NOT EXISTS staging (
  id varchar,
  name varchar,
  supertype varchar,
  types varchar,
  price_date date,
  normal_market float,
  normal_low float,
  normal_high float,
  reverse_market float,
  reverse_low float,
  reverse_high float,
  holo_market float,
  holo_low float,
  holo_high float,
  month varchar
);

-- Insercion de datos, truncamos la tabla 'por si las moscas' y copiamos del CSV
TRUNCATE TABLE staging;
\copy staging FROM '../data/clean_data.csv' WITH (FORMAT CSV, HEADER, NULL '');

-- Creacion de tabla de Cards
CREATE TABLE IF NOT EXISTS cards (
  id VARCHAR PRIMARY KEY,
  name VARCHAR,
  supertype VARCHAR,
  type VARCHAR
);

-- Insercion de datos, se hacen queries sobre staging para obtener la informacion de las cargas
INSERT INTO cards (id, name, supertype, type)
SELECT DISTINCT
  id,
  name,
  supertype,
  types
FROM staging
ON CONFLICT (id) DO NOTHING;

-- Creacion de tabla de pricepoints, para almacenar los precios de las cartas
CREATE TABLE IF NOT EXISTS pricepoints (
  id SERIAL PRIMARY KEY,
  card_id VARCHAR NOT NULL REFERENCES cards (id),
  month VARCHAR(3) NOT NULL,
  type VARCHAR NOT NULL CHECK (type IN ('normal', 'reverse', 'holofoil')),
  high float,
  low float,
  market float,
  price_date date
);

-- Truncamos la tabla 'por si las moscas'
TRUNCATE TABLE pricepoints;

-- Insertamos informacion a sobre los pricepoints de las cartas normales
INSERT INTO pricepoints (card_id, month, type, high, low, market, price_date)
  SELECT
    id AS card_id,
    month AS month,
    'normal' AS type,
    normal_high AS high,
    normal_low AS low,
    normal_market AS market,
    price_date AS price_date
  FROM staging
  WHERE normal_market IS NOT NULL;

-- Insertamos informacion sobre los pricepoints de las cartas reverse holo
INSERT INTO pricepoints (card_id, month, type, high, low, market, price_date)
  SELECT
    id AS card_id,
    month AS month,
    'reverse' AS type,
    reverse_high AS high,
    reverse_low AS low,
    reverse_market AS market,
    price_date AS price_date
  FROM staging
  WHERE reverse_market IS NOT NULL;

-- Insertamos informacion sobre los pricepoints de las cartas holofoil
INSERT INTO pricepoints (card_id, month, type, high, low, market, price_date)
  SELECT
    id AS card_id,
    month AS month,
    'holofoil' AS type,
    holo_high AS high,
    holo_low AS low,
    holo_market AS market,
    price_date AS price_date
  FROM staging
  WHERE holo_market IS NOT NULL;
DROP TABLE staging;
