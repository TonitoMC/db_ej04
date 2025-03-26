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

TRUNCATE TABLE staging;
\copy staging FROM '../data/clean_data.csv' WITH (FORMAT CSV, HEADER, NULL '');
