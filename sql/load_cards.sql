-- Creacion de tabla de Cards
CREATE TABLE IF NOT EXISTS cards (
  id VARCHAR PRIMARY KEY,
  name VARCHAR,
  supertype VARCHAR,
  type VARCHAR
);

INSERT INTO cards (id, name, supertype, type)
SELECT DISTINCT
  id,
  name,
  supertype,
  types
FROM staging
ON CONFLICT (id) DO NOTHING;
