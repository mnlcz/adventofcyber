# Advent of Cyber Día 3: Brute-forcing

## Introducción

La historia del día de hoy trata sobre un ataque que sufrieron los protagonistas, sus sistemas fueron bloqueados y la contraseña para acceder a los sistemas de control fué modificada. Ya entrando más en detalles técnicos, se va a aprender sobre contraseñas: sus combinaciones, complejidad, creación y prueba. Se hará uso de distintas herramientas como **hydra** y **crunch**.

## Objetivos de aprendizaje

- Aprender sobre la complejidad y las distintas combinaciones posibles de una contraseña.
- Entender como el número de combinaciones afecta a la viabilidad de atacar mediante fuerza bruta.
- Aprender a generar contraseñas mediante **crunch**.
- Aprender a probar contraseñas automáticamente mediante **hydra**.

## Viabilidad de la estrategia de fuerza bruta

En los siguientes capítulos se dará respuesta a las siguientes preguntas:

1. ¿Cuántos PIN codes puedo tener?
2. ¿Cuántas contraseñas distintas puedo generar?
3. ¿Cuánto tarda la estrategia de fuerza bruta en obtener una contraseña?

### Contando PIN codes

En este apartado se habla de los PIN codes como medida de seguridad para varios sistemas, mencione que es un tipo de medida propensa a ataques si no se toman los cuidados necesarios. Se verá un ejemplo concreto de esto.

Se nos plantea una situación en la que es necesario obtener un PIN de cuatro dígitos. Para evaluar la cantidad de posibles respuestas basta con encarar matemáticamente al problema. El total sería de 10000 códigos, se deduce de hacer `10 x 10 x 10 x 10` o `10^4`.

### Contando contraseñas

Acá se nos plantea una situación similar a la del apartado previo, se quiere obtener una combinación de 4 caracteres. A diferencia del caso de los PIN codes, una contraseña puede tener:

- Dígitos del 0 al 9 (10 dígitos)
- Letras mayúsculas (26 letras para el alfabeto inglés)
- Letras minúsculas (26 letras para el alfabeto inglés)

Sumando todo nos da como resultado 62 posibles opciones, como en este caso se trata de una contraseña de 4 caracteres el total sería `62^4` (14.776.336).

Queda claro como una contraseña de no tanta longitud tiene muchas posibles combinaciones, hay que tener en cuenta que en este ejemplo no se tuvo en cuenta los símbolos, si quisiéramos incluirlos agregaríamos 30 caracteres extras al cálculo.

### Cuánto se tarda en *brute-force* una contraseña

Continuando con el ejemplo previo, si quisiéramos obtener la contraseña de 4 caracteres mediante fuerza bruta, nos llevaría hasta 4 horas. A este número se llegó con el siguiente cálculo:

- Las opciones son `62^4`
- Probar una contraseña nos lleva `0.001` segundos
- `62^4 x 0.001 = 14776` segundos, lo que equivale a `4.1` horas

En la realidad el número podría no ser tan elevado, ya que la contraseña no necesariamente es la última opción, puede encontrarse a la mitad o incluso cerca del principio, por lo que podemos concluir que en promedio se tardarían 2 horas.

Algo importante a aclarar es que el valor de 0.001 segundos referente a calcular una contraseña es algo planteado puramente para el ejemplo, en la realidad hay muy pocos sistemas que nos permitan esta velocidad.

Por último en este apartado nos menciona que dado todo lo que aprendimos, es bastante comprensible el por qué se pide que las contraseñas sean largas y contengan caracteres variados.

## Resolución

Para el resolver el día de hoy se va a hacer uso de la AttackBox y la VM.

Siguiendo las instrucciones iniciales accedemos a la página especificada y nos encontramos con un display de 3 dígitos, este valor va a ser el que se tiene que obtener.

### Generando el listado de contraseñas

Analizando el tablero vemos que tiene tanto valores numéricos como letras mayúsculas de la A hasta la F. Con esta información podemos utilizar **Crunch**, una herramienta que genera **una lista de posibles combinaciones basándose en un criterio**. El comando en este caso es el siguiente:

```ps1
crunch 3 3 0123456789ABCDEF -o 3digits.txt
```

Donde cada apartado corresponde a:

- `3`: tamaño mínimo de la contraseña
- `3`: tamaño máximo de la contraseña
- `0123456789ABCDEF`: set de caracteres a utilizar
- `-o 3digits.txt`: guarda el output en un archivo

### Usando el listado generado

Ya con la lista de combinaciones generada por crunch podemos empezar a probar, sin embargo probar cada caso manualmente es una tarea muy tediosa, por lo que se va a hacer uso de **Hydra**, una herramienta para **probar contraseñas de manera automática**.

Antes de comenzar nos explica que tenemos que acceder al código HTML de la página, nos hace enfoque en una parte particular del mismo.

![HTML](img/1.png)

Donde:

1. El método HTTP es `POST`
2. La URL es `http://MACHINE_IP:8000/login.php`
3. El PIN que se envía tiene el nombre de `pin`

En otras palabras, la página principal recibe un input del usuario y lo envía a `/login.php` utilizando el nombre de `pin`.

Los 3 valores obtenidos son necesarios para poder ejecutar hydra. El comando es el siguiente:

```ps1
hydra -l '' -P 3digits.txt -f -v MACHINE_IP http-post-form "/login.php:pin=^PASS^:Access denied" -s 8000
```

Donde:

- `-l ''`: indica que el nombre de usuario es vacío, ya que se nos pide solo la contraseña
- `-P 3digits.txt`: especifica el archivo de combinaciones
- `-f`: hace que hydra se detenga una vez que obtiene la contraseña correcta
- `-v`: hace que se vea el output detallado en la terminal
- `MACHINE_IP`: la IP del objetivo
- `http-post-form`: el método HTTP que se va a utilizar
- `"/login.php:pin=^PASS^:Access denied"`: consta de 3 apartados separados por `:`
  - `/login.php`: la página a la que se envía el PIN
  - `pin=^PASS^`: reemplaza `^PASS^` por el valor de la lista que se este probando
  - `"Access denied"`: indica que las contraseñas incorrectas nos llevan a una página que contiene el texto "Access denied"
- `-s 8000`: indica el puerto del objetivo

### Respuestas

Luego de ejecutar hydra obtuvimos el valor del PIN: **6F5**. Y el valor de la flag es: **THM{pin-code-brute-force}**.
