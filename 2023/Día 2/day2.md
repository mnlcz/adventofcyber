# Advent of Cyber Día 2: Log analysis

## Introducción

En este día se va trabajar con la ciencia de datos, más específicamente con Python y las Jupyter Notebooks. Se verá la teoría y se resolverán ejercicios planteados en las notebooks brindadas en la máquina virtual.

## Objetivos de aprendizaje

- Introducción a la ciencia de datos y cómo utilizarla en ciberseguridad
- Introducción a Python
- Trabajar con algunas de las biblotecas más utilizadas como Pandas y Matplotlib

## Ciencia de datos

El objetivo resumido de la ciencia de datos es la interpretación correcta de información para resolver una/s pregunta/s. Este proceso generalmente involucra programación, estadística y, en los últimos tiempos, inteligencia artificial.

Se puede separar los roles de un científico de datos en las siguientes categorías:

| Rol             | Descripción                                                                                         |
| :-------------- | :-------------------------------------------------------------------------------------------------- |
| Data collection | Consiste en recolectar la *raw data*.                                                               |
| Data processing | Consiste en transformar la *raw data* en un formato estándar con el que el analista pueda trabajar. |
| Data mining     | Consiste en crear relaciones entre los distintos elementos presentes en la información , encontrar patrones y correlaciones. |
| Analysis        | Consiste en explorar la información, en esta etapa se empiezan a responder las preguntas que se tenían al comienzo del estudio. |
| Communication | Consiste en representar toda la información y las respuestas obtenidas de manera visual. |

### Ciencia de datos aplicada a ciberseguridad

La ciencia de datos cada vez se utiliza más en el campo de la ciberseguridad. Analizar datos como *log events* le permite a los especialistas entender más fácilmente lo que sucede en una determinada organización. También se la utiliza en la detección de anomalías. Otros usos podrían ser:

- **SIEM**: los sistemas SIEM (*Security information and event management*) recolectan y analizan grandes cantidades de información sobre una organización.
- **Threat trend analysis** : las nuevas amenazas se pueden localizar y estudiar.
- **Predictive analysis**: analizando eventos históricos se puede crear una potencial imagen de lo que podrían ser las amenazas futuras. Esto puede ayudar a la prevención de accidentes.

### Introducción a las Jupyter Notebooks

En este apartado se explica qué es y se da una breve introducción al funcionamiento de las Jupyter Notebooks. Dado que ya tengo experiencia con esta tecnología no se agregará en este apunte.

## Python

### Introducción a Python

En este apartado se ve una breve introducción a Python (variables, listas, etc) y se trabaja con una notebook presente en la VM del día, no lo agrego en este apunte debido a que ya tengo experiencia con el lenguaje.

### Pandas

Pandas es una biblioteca especializada en el trabajo con *data sets*. Los data set son una colección de información relacionada, por ejemplo una lista de ventas.

Pandas nos permite manipular, analizar, explorar y limpiar data sets.

#### Series

Similar a un `Map` o `Dictionary` en otros lenguajes, se trata de una estructura de datos *clave-valor*. Un ejemplo en código:

```python
import pandas as pd

transportation = ['Train', 'Plane', 'car']
transportation_series = pd.Series(transportation)
```

En este caso la clave sería el índice.

#### DataFrames

Son una extensión de las series previamente vistas. Se trata de un conjunto de series y se los puede pensar como una base de datos o una *spreadsheet*. En el siguiente ejemplo se creará un `DataFrame` con un campo para el nombre, otro para la edad y un último para el país.

```python
data = [['Ben', 24, 'UK'],
        ['Jacob', 32, 'USA'],
        ['Alice', 19], 'Germany']

df = pd.DataFrame(data, columns=['Name', 'Age', 'Country of Residence'])
```

Entrando un poco en la manipulación, supongamos que queremos devolver unicamente una fila en concreto:

```python
# fila 2: nos traería la información de Jacob
df.loc(1)
```

#### Grouping

Es una operación en Pandas que nos permite agrupar nuestra información en categorías y hacer algo con ellas, por ejemplo: agrupar columnas, agrupar filas, comparar, etc.

En el siguiente ejemplo de uso se utiliza un archivo `.csv` presente en la VM del día, el mismo tiene 3 campos: Empleado, Departamento y Premio. El enunciado menciona que se quiere agrupar las columnas Departamento y Premio para ver cuántos premios ganó cada departamento:

```python
df = pd.read_csv("awards.csv")
df.groupby(['Department'])['Prize'].sum()
```

También muestra el uso de `describe`, una función que muestra un sumario de toda la información en porcentajes:

```python
df.groupby(['Department'])['Prize'].describe()
```

### Matplotlib

Matplotlib es una biblioteca muy conocida, se encarga de crear representaciones gráficas de nuestra información.

#### Primer plot

Primero se importan las bibliotecas a usar:

```python
import pandas as pd
import matplotlib.pyplot as plt
```

Ahora es necesario especificarle a Matplotlib que tenemos un entorno (Jupyter), ya que por defecto los gráficos se muestran en una nueva ventana.

```python
%matplotlib inline
```

Ya con esto se puede crear el primer gráfico:

```python
plt.plot(['January', 'February', 'March', 'April'], [8, 14, 23, 40])
```

Sin embargo le faltan algunas descripciones generales como de los ejes, para agregarlas:

```python
plt.xlabel('Months of the year')
plt.ylabel('Number of toys produces')
plt.title('A line graph showing the number of toys produced between september and december')

plt.plot(['September', 'October', 'November', 'December'], [8, 14, 80, 160])
```

#### Bar graph

Para demostrar este tipo de gráfico se hace uso de un `.csv` presente en la VM del día. Se trata de un conjunto de bebidas alcohólicas y sus puntuaciones, se quiere ver cuales son las más populares. Los pasos a efectuar son los siguientes:

1. Leer el archivo csv
2. Extraer las columnas Drink y Vote y guardarlas en variables
3. Representar el gráfico

```python
# Paso 1
spreadsheet = pd.read_csv('drinks.csv')

# Paso 2
drinks = spreadsheet['Drink']
votes = spreadsheet['Vote']

# Paso 3
plt.figure(figsize=(10, 6)) # ajusta el tamaño de la figura
plt.barh(drinks, votes, color='skyblue') # bar graph 'h'orizontal
plt.xlabel('Number of votes')
plt.ylabel('Name of drink')
plt.title('A bar graph showing the employees favourite drinks')
plt.gca().invert_yaxis() # invierte el eje y para que se entienda mejor
```

## Resolución

### Enunciado

El ejercicio nos pide trabajar con una notebook específica y hacer uso de todo lo aprendido. El enunciado menciona que tenemos que:

1. Analizar un archivo `.csv`
2. Agrupar la información en 3 campos: `Source`, `Destination` y `Protocol`
3. Aplicar `sum`, `average`, `size` y `describe`

Y responder a las siguientes preguntas:

1. Paquetes capturados
2. Dirección IP que envió más tráfico
3. Protocolo más usado

### Código

#### 1

```python
df.count()
```

#### 2

```python
df.groupby(['Source']).size().sort_values(ascending=False)
```

#### 3

```python
df.groupby(['Protocol']).size().sort_values(ascending=False)
```

### Respuesta

<details>
<summary>Spoiler</summary>
<table>
  <thead>
    <tr>
      <th style="text-align:center">Información</th>
      <th style="text-align:center">Valor</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:center">Paquetes capturados</td>
      <td style="text-align:center"><code>100</code></td>
    </tr>
    <tr>
      <td style="text-align:center">IP con más tráfico</td>
      <td style="text-align:center"><code>10.10.1.4</code></td>
    </tr>
    <tr>
      <td style="text-align:center">Protocolo más frecuente</td>
      <td style="text-align:center"><code>ICMP</code></td>
    </tr>
  </tbody>
</table>
</details>

### [Volver a inicio](../../README.md)
