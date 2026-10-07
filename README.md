# Automatización API Platzi Fake Store

Proyecto de pruebas automatizadas para la API https://api.escuelajs.co/api/v1
(la documentación está en https://fakeapi.platzi.com/). Usé Karate para los
escenarios, Gradle para compilar y correr, y Cucumber para el reporte.

## Qué necesitas
- Java 17 o superior (yo lo probé con Java 21)
- Git

## Cómo correrlo
Clona el repositorio y desde la carpeta del proyecto ejecuta:

    .\gradlew.bat test      (Windows)
    ./gradlew test          (Linux o Mac)

La primera vez descarga las dependencias, así que puede tardar un poco.

## Dónde queda el reporte
- Cucumber: `build/cucumber-html-reports/overview-features.html`
- Karate: `build/karate-reports/karate-summary.html`

Se abren con el navegador.

## Cómo está organizado
(pega aquí la salida de `tree src /F`)

- `features/` tiene los escenarios en Gherkin, uno por servicio: productos,
  filtros, categorías y usuarios.
- `features/common/` tiene escenarios que se reutilizan para crear datos.
  Llevan la etiqueta `@ignore` para que no corran solos.
- `data/` tiene los JSON de entrada, válidos e inválidos.
- `schemas/` tiene los esquemas para validar la estructura de las respuestas.
- `karate-config.js` guarda la URL base.

## Qué se prueba
Son 25 escenarios con GET, POST, PUT y DELETE: 9 de productos, 5 de filtros,
5 de categorías y 6 de usuarios. Cada servicio tiene al menos una prueba
negativa. Se validan los códigos 200, 201, 400, 404 y 500, además de headers,
cuerpo y estructura del JSON.

## Una nota sobre los datos
La API es pública y la usa más gente, así que los datos cambian. Por eso los
escenarios que actualizan o borran crean antes su propio registro, con nombre
o email único, y no tocan datos de otros.

## Lo que encontré en la API
Estas son diferencias entre lo que esperaba y lo que respondió:

- Pedir un producto, categoría o usuario que no existe responde 400, no 404.
  El 404 solo aparece cuando la ruta no existe.
- `GET /users/1` devuelve la contraseña en texto plano.
- Un PUT con el body incompleto (solo título y precio) devuelve 500. Con el
  body completo funciona.
- El DELETE responde 200, pero con `text/html` y el texto `true`, no con JSON.
- Al repetir un título en un PUT aparece un error de base de datos
  (`SQLITE_CONSTRAINT_UNIQUE`) con código 400.
- El campo `message` de los errores a veces es un texto y a veces una lista.

Hay un escenario marcado `@known-bug` que afirma el comportamiento correcto
y falla por el defecto del PUT. Lo excluí de la ejecución normal para que el
resultado no quede en rojo por algo de la API.

## Qué más probaría
(escribe aquí 3 o 4 ideas tuyas)

## Respuestas
(escribe aquí tus respuestas a las 4 preguntas)