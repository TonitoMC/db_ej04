-- Carga la informacion de los precios

-- Creacion de tabla de pricepoints
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

TRUNCATE TABLE pricepoints;

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
