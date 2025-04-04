-- 1. Cuales son las 5 cartas  mas caras actualmente en el mercado (holofoil)
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

-- 2. Cuantas cartas tienen un precio de mercado en holofoil  mayor a $100
-- Las cartas son unicas, se filtran en pricepoints de holo + market > 100. Toma en cuenta si una tuvo
-- precio > 100 en cualquier update
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

-- 3. Cual es el precio promedio de una carta en holofoil en la ultima actualizacion
-- Se filtro la informacion por mes = marzo, luego se obtuvo el promedio
SELECT 
    AVG(market) AS avg_holo
FROM pricepoints
WHERE 
    type = 'holofoil' AND
    month = 'mar';

-- 4. Cuales son las cartas que han bajado de precio la ultima actualizacion
-- Hay reverse, normal, holo para cada carta. Se toma en cuenta especificamente
-- si bajo 'Charizard Holo' y 'Charizard Normal' por separado
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

-- 5. Que tipo de Pokemon tiene el precio promedio mas alto en holofoil
-- Se toman en cuenta ambos pricepoints de holofoil (Febrero y Marzo) para
-- obtener el promedio
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

-- 6. Cual es la diferencia de precio entre la carta mas cara y la mas barata en holofoil
-- Se toma el market price para la comparacion, utilizando Febrero y Marzo
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

-- 7. Cuantas cartas tienen precios disponibles en todas las condiciones
-- Se tomo en cuenta el pricepoint en cualquiera de las actualizaciones, con que
-- haya por lo menos un holo, normal y reverse en cualquiera
SELECT c.id, c.name
FROM cards c
WHERE EXISTS (SELECT 1 FROM pricepoints WHERE card_id = c.id AND type = 'holofoil')
  AND EXISTS (SELECT 1 FROM pricepoints WHERE card_id = c.id AND type = 'normal')
  AND EXISTS (SELECT 1 FROM pricepoints WHERE card_id = c.id AND type = 'reverse')
ORDER BY c.name;

-- 8. Cual fue la fecha mas reciente de actualizacion de precios
SELECT MAX(price_date) AS last_update
FROM pricepoints;

-- 9. Cuales son las 3 cartas con la mayor diferencia entre el precio mas alto
-- y el precio  mas bajo en holofoil.
-- Para esto, tomamos los precios mas altos historicamente y los precios mas
-- bajos historicamente. Ej. un charizard se vendio por 10000$ en febrero
-- y luego 0.05$ en marzo, se toman los 1000$ de febrero y los 5c de marzo
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

-- 10. Cual es la carta mas cara de cada tipo de pokemon
-- Utilice el precio de mercado historico, probe con el mercado
-- actual y es lo mismo
SELECT DISTINCT ON (c.type)
  c.name,
  c.type AS pokemon_type,
  p.high AS price -- Precio mas alto historico, por precio de mercado actual es lo mismo
FROM pricepoints p
JOIN cards c ON p.card_id = c.id
WHERE
  c.supertype = 'Pokémon' AND
  c.type IS NOT NULL
ORDER BY c.type, p.market DESC;
