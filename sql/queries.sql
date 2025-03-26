-- 5 cartas mas caras en el mercado (holofoil)
-- Se toman en cuenta las cartas actualizadas en marzo, utilizando el market price
SELECT
  c.name,
  p.market AS holo_price
FROM pricepoints p
JOIN cards c ON p.card_id = c.id
WHERE
  p.type = 'holofoil' AND
  p.month = 'mar'
ORDER BY p.market DESC
LIMIT 5;

-- Cartas con precio arriba de 100 en holofoil
-- Las cartas son unicas, se filtran en pricepoints de holo + market > 100. Toma en cuenta si una
-- tuvo un precio > 100 en cualquier update
SELECT COUNT(DISTINCT card_id) AS cards_holo_100
FROM pricepoints
WHERE
  type = 'holofoil' AND
  market > 100;

-- Si quisieramos filtrar unicamente la actualizacion mas reciente
SELECT COUNT(DISTINCT card_id) AS cards_holo_100_mar
FROM pricepoints
WHERE
  type = 'holofoil' AND
  market > 100 AND
  month = 'mar';

-- Holofoil promedio en ultima actualizacion (filtrado por mes = marzo)
SELECT 
    AVG(market) AS avg_holo
FROM pricepoints
WHERE 
    type = 'holofoil' AND
    month = 'mar';

-- Cuales cartas han bajado de precio
-- Hay que tomar en cuenta que hay reverse, holo y normal para cada carta
-- Se comparan los precios en marzo y febrero
SELECT
  c.name,
  p_feb.type,
  p_feb.market AS feb_price,
  p_mar.market AS mar_price,
  (p_mar.market - p_feb.market) AS price_change
FROM
  (SELECT * FROM pricepoints WHERE month = 'feb') p_feb
JOIN
  (SELECT * FROM pricepoints WHERE month = 'mar') p_mar
  ON p_feb.card_id = p_mar.card_id AND p_feb.type = p_mar.type -- El tipo debe ser el mismo, no se puede comparar un holo con una normal anterior
JOIN cards c ON p_feb.card_id = c.id
WHERE p_mar.market < p_feb.market
ORDER BY price_change ASC
LIMIT 5; -- Son bastantes, limit a 5

-- Tipo de pokemon mas caro en Holo (Toma en cuenta feb y marzo)
-- Usando market price, pienso que si hubiera querido highest y lowest
-- se hubiera especificado
SELECT
  c.type AS pokemon_type,
  AVG(p.market) AS avg_holo
FROM pricepoints p
JOIN cards c ON p.card_id = c.id
WHERE
  p.type = 'holofoil' AND
  c.supertype = 'Pokémon'
GROUP BY c.type
ORDER BY avg_holo DESC
LIMIT 1;

-- Diferencia entre carta mas cara y mas barata en holo
-- Usando market price
WITH holo_prices AS (
  SELECT
    c.name,
    p.market
  FROM pricepoints p
  JOIN cards c ON p.card_id = c.id
  WHERE p.type = 'holofoil'
)
SELECT
  MAX(market) - MIN(market) AS price_diff,
  MAX(market) AS max_price,
  MIN(market) AS min_price
FROM holo_prices;

-- Cartas con precios disponibles en todas las condiciones
SELECT c.id, c.name
FROM cards c
WHERE EXISTS (SELECT 1 FROM pricepoints WHERE card_id = c.id AND type = 'holofoil')
  AND EXISTS (SELECT 1 FROM pricepoints WHERE card_id = c.id AND type = 'normal')
  AND EXISTS (SELECT 1 FROM pricepoints WHERE card_id = c.id AND type = 'reverse')
ORDER BY c.name;

-- Ultima actualizacion
SELECT MAX(price_date) AS last_update
FROM pricepoints;

-- Cartas con mayor diferencia
SELECT
  c.name,
  MAX(p.high) - MIN(p.low) AS price_difference,
  MAX(p.high) AS highest,
  MIN(p.low) AS lowest
FROM pricepoints p
JOIN cards c ON p.card_id = c.id
WHERE p.type = 'holofoil'
GROUP BY c.id, c.name
ORDER BY price_difference DESC
LIMIT 3;

-- Precio de mercado historico
SELECT DISTINCT ON (c.type)
  c.name,
  c.type AS pokemon_type,
  p.high AS price -- Precio mas alto historico, por precio de mercado historico es lo mismo
FROM pricepoints p
JOIN cards c ON p.card_id = c.id
WHERE
  c.supertype = 'Pokémon' AND
  c.type IS NOT NULL
ORDER BY c.type, p.market DESC;



