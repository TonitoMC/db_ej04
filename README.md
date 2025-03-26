# Ejercicio 4 - Pokémon
## Instrucciones
Diseñar la base de datos para almacenar la  información de las cartas Pokémon y sus precios, utilizar al menos dos tablas y cargar información de los CSV.
## Ubicación de Archivos
- En el root se encuentra cleaning.ipynb. Es un ligero pre procesamiento de datos que realicé, no estoy muy familiarizado con las tarjetas de Pokemón así que exploré un poco. Únicamente renombré y removí columnas, adicionalmente combiné todo dentro de un .CSV para facilitar la carga de datos.
- En data se encuentran los archivos .CSV originales, al igual que un clean_data.csv que es de donde cargué los datos a la DB.
- En sql se encuentra el script para ingresar información a la base de datos del .CSV, al igual que los queries que se requieren para responder las preguntas.

## Diagrama ER
Decidí optar por un diseño bastante simple, de esta manera facilitando un poco más los queries. Por ejemplo, adicioné el mes para tener claro cuáles son las actualizaciones recientes y poder sacar información sobre cambios fácilmente. Las columnas de pricepoints no pueden ser null, ya que esto se filtra al insertar los datos y las cartas si pueden tener un tipo null al ser un entrenador por ejemplo.

![image](https://github.com/user-attachments/assets/61468c4e-2f96-4617-b94f-54430c1913c9)

## Respuestas a las Preguntas

1. ¿ Cuáles son las 5 cartas más caras actualmente en el mercado (holofoil) ?

  - Umbreon ex - $1552.15
  - Umbreon VMAX - 1467.33
  - Rayquaza VMAX - 803.64
  - Gengar VMAX - 682.49
  - Giratina V - 663.36

2. ¿ Cuántas cartas tienen un precio de mercado en holofoil mayor a $100 ?

  - En ambos meses (históricamente) 74, actualmente (solo marzo) 72

3. ¿ Cuál es el precio promedio de una carta en holofoil en la última actualización ?

  - $13.49

4. ¿ Cuáles son las cartas que han bajado de precio en la última actualización ?
Son demasiadas para listar, en el query se limita a las 5 con mayor cambio

  - Umbreon VMAX -$280.40
  - Umbreon ex -$58l.69
  - Giratina V -$44.84
  - Gengar VMAX -$42.05
  - Sylveon ex -$39.63

6. ¿ Qué tipo de Pokémon tiene el precio promedio más alto en holofoil ?

  - Dragón con un promedio de $28.60

6. ¿ Cuál es la diferencia de precio entre la carta más cara y la más barata en holofoil ?

  - $1747.68 comparando precio de mercado en ambas actualizaciones

8. ¿ Cuál fue la fecha más reciente de actualización de precios ?

  - 17-03-2025

9. ¿ Cuáles son las 3 cartas con la  mayor diference entre el precio más alto y el más bajo en holofoil?

  Se tomó en cuenta el precio más alto y más bajo histórico (febrero + marzo)

  - Cinccino - 10,387.34
  - Iron Leaves ex - 9,998.86
  - Walking Wake ex - 9,998.78

10. ¿ Cuál es la carta más cara de cada tipo de Pokémon ?

  - Colorless - Dark Dragonite
  - Darkness - Umbreon Max
  - Dragon - Rayquaza Max
  - Fighting - Greninja Ex
  - Fire - Charizard
  - Grass - Leafon VMAX
  - Lightning - Pikachu Ex
  - Metal - Gholdengo ex
  - Psychic - Sylveon ex
  - Agua - Glaceon VMAX

