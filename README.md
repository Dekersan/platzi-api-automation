## Escenarios adicionales propuestos
- **Autenticación JWT:** login con credenciales válidas e inválidas,
  consulta del perfil con token válido, vencido o ausente, y renovación del
  token con `/auth/refresh-token`.
- **Reglas de contraseña:** la API exige letras y números, con un mínimo de
  4 caracteres. Falta cubrir contraseñas con símbolos y en el límite.
- **Paginación con valores extremos:** `limit` en 0, negativo o muy grande, y
  `offset` superior al total de productos.
- **Integridad referencial:** crear un producto con un `categoryId`
  inexistente. Con `categoryId: 0` la API no devolvió ningún mensaje de
  validación sobre la categoría.
- **Límites de longitud** en título, nombre y descripción.
- **Rendimiento:** una prueba de carga básica, dado que el servicio mostró
  lentitud en algunas ejecuciones.

## Respuestas al entregable

**1. ¿Cuáles fueron los principales desafíos al implementar las funcionalidades?**

El principal desafío fue que el comportamiento real de la API no coincidía
con el esperado. Un recurso inexistente responde 400 en lugar de 404, y un
PUT con el cuerpo incompleto responde 500. Para no automatizar sobre
supuestos, exploré cada endpoint manualmente antes de escribir los
escenarios y fijé los resultados esperados según las respuestas observadas.
Los casos que se apartan de lo correcto quedaron documentados como hallazgos.

El segundo desafío fue la naturaleza compartida de la API. Los datos cambian
entre ejecuciones, por lo que un identificador fijo no es confiable. Además,
un escenario de actualización pasaba en la primera ejecución y fallaba en la
siguiente, porque un título repetido violaba la restricción de unicidad del
campo `slug`. Lo resolví creando en cada escenario su propio recurso, con un
nombre o email único generado en tiempo de ejecución.

**2. ¿Qué técnicas de prueba se usaron y qué enfoque se dio a la automatización?**

Se aplicaron pruebas funcionales positivas y negativas, con datos válidos e
inválidos. Para los casos negativos se consideraron identificadores
inexistentes y no numéricos, cuerpos incompletos o con campos vacíos, rangos
de filtro invertidos y rutas inexistentes. Se cubrieron los códigos 200, 201,
400, 404 y 500.

En la automatización los escenarios se escriben en Gherkin y los datos de
entrada se separan en archivos JSON. Los pasos para crear registros se
reutilizan desde `features/common`, y la URL base se centraliza en
`karate-config.js`. Los escenarios que modifican o eliminan información
crean su propio recurso previamente, de modo que son independientes entre sí
y repetibles.

**3. ¿Cómo se gestionó la validación de datos y de la estructura del JSON?**

La estructura se valida con esquemas JSON en la carpeta `schemas/`, usando
los marcadores de Karate (`#number`, `#string`, `#array`) y `match each` para
verificar todos los elementos de una lista. Además de la estructura, cada
escenario comprueba el código de estado, el header `Content-Type` y valores
concretos del cuerpo, por ejemplo que el título actualizado sea el enviado.

En las respuestas de error se verifican los campos `statusCode`, `error` y
`message`. Como `message` es un texto en algunos errores y una lista en
otros, cada escenario negativo valida el formato correspondiente. Para no
depender de datos fijos, el escenario de consulta por identificador toma el
primer id del listado.

**4. ¿Qué aprendizajes se obtuvieron y cómo aportan al crecimiento profesional?**

Reforcé la importancia de explorar un servicio antes de automatizarlo y de
distinguir entre lo que la API hace y lo que debería hacer. Esa distinción
me llevó a documentar hallazgos con evidencia, como la contraseña expuesta
en texto plano o el mensaje de error de base de datos que llega al cliente.
También profundicé en Karate, Gradle y reportes con Cucumber, en el diseño de
pruebas independientes y repetibles sobre datos compartidos, y en la lectura
de fallos para encontrar su causa. Todo esto mejora mi criterio para
priorizar casos, comunicar defectos con claridad y construir pruebas
mantenibles.