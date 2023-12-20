# Advent of Cyber Día 5: Ingeniería inversa

## Introducción

La historia de este día cuenta que una herramienta interna que tenían los protagonistas para poder recuperar backups no está funcionando. Luego de investigar encontraron una versión antigua de la misma, la cual podían utilizar para encontrar el problema de fondo, sin embargo, esta versión solo funciona en sistemas DOS antiguos.

Se va a trabajar con una VM con DOS, además al ser un sistema poco común, THM nos recuerda una serie de comandos para movilizarnos y realizar tareas comunes en el sistema. El objetivo final es recuperar un archivo `.bak`.

Con esta introducción queda bastante claro que el problema de hoy tiene mucho que ver con trabajar en entornos *legacy*, también aclara que si bien no es muy común hoy en día, es útil aprenderlo de todas formas.

## Objetivos de aprendizaje

- Aprender a navegar un sistema poco usual.
- Aprender sobre DOS y su relación con el Símbolo del sistema presente en el Windows actual.
- Aprender sobre el firmado de archivos y análisis del sistema de archivos.

## Comandos DOS

| Comando | Operación                               |
| :------ | :-------------------------------------- |
| `CD`    | Cambiar directorio                      |
| `DIR`   | Listar archivos y directorios           |
| `TYPE`  | Ver el contenido de un archivo de texto |
| `CLS`   | Limpiar la pantalla                     |
| `HELP`  | Información de comandos DOS             |
| `EDIT`  | El editor de texto                      |

## Resolución

Como se mencionó previamente el objetivo es recuperar un archivo `.bak` presente en el sistema. Al encontrarlo y hacer uso de la herramienta de backup presente en `C:\TOOLS\BACKUP`:

```Bash
BUMASTER.EXE C:\AC2023.BAK
```

Nos da un error, dice que el archivo no puede leerse y que revisemos el archivo `README.txt` para más detalles. Al leer dicho archivo vemos que los errores de lectura se dan generalmente por problemas en los primeros bytes del archivo, dice que los bytes de la firma deberían ser `41 43` (hex) y que en caso de no serlo, podemos concluir el archivo está corrupto o no es compatible.

### Firma de los archivos

La firma de un archivo, también conocida como *magic bytes*, se trata de una secuencia de bytes presentes al principio de un archivo, esta secuencia permite verificar el tipo y el formato del archivo. La secuencia generalmente corresponde a caracteres ASCII para que pueda ser comprensible.

En ciberseguridad las firmas son cruciales para identificar archivos y formatos, se encuentran presentes en muchísimas áreas como análisis de malware, tráfico de red, forense, etc.

Acá va una lista de firmas usuales y sus correspondientes tipos:

| Formato de archivo     | Bytes mágicos           | ASCII |
| :--------------------- | :---------------------- | :---- |
| Imagen PNG             | 89 50 4E 47 0D 0A 1A 0A | %PNG  |
| Imagen GIF             | 47 49 46 38             | GIF8  |
| Ejecutable Windows/DOS | 4D 5A                   | MZ    |
| Ejecutable ELF Linux   | 7F 45 4C 46             | .ELF  |
| Audio MP3              | 49 44 33                | ID3   |

### Reparando el archivo bak

Viendo el contenido del archivo nos damos cuenta que los bytes mágicos no están correctos. Los modificamos para que queden acordes al formato del archivo (en este caso sería 41 43 en hex y AC en ASCII).

Ya con esto podemos volver a ejecutar la herramienta y recuperar la información.

### Respuesta

THM nos pide la siguiente información:

| Información                                    | Valor                     |
| :--------------------------------------------- | :------------------------ |
| Tamaño en bytes del archivo `.bak`             | 12704                     |
| Nombre de la herramienta de recuperación       | BackupMaster 3000         |
| Bytes mágicos correctos para el archivo `.bak` | 41 43                     |
| Valor de la flag                               | THM{0LD_5CH00L_C00L_d00D} |

### [Volver a inicio](../../README.md)
