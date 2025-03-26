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
-- Las cartas son unicas, se filtran en pricepoints de holo + market > 100.
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
  p_feb.market AS feb_price
  p_mar.market AS mar_price
  (p_mar.market - p_feb.market) AS price_change
FROM
  (SELECT * FROM pricepoints WHERE month = 'feb') p_feb
JOIN
  (SELECT * FROM pricepoints WHERE month = 'mar') p_mar
  ON p_feb.card_id = p_mar.card_id AND p_feb.type = p_mar.type
JOIN cards c ON p_feb.card_id = c.id
WHERE p_mar.market < p_feb.market
ORDER BY price_change ASC;

-- Tipo de pokemon mas caro en Holo (Toma en cuenta feb y marzo)

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
