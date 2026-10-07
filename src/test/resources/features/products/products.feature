@products
Feature: Servicio de productos

  Background:
    * url baseUrl
    * def productSchema = read('classpath:schemas/product-schema.json')

  @smoke @positive
  Scenario: Listar productos
    Given path 'products'
    When method GET
    Then status 200
    And match header Content-Type contains 'application/json'
    And match response == '#array'
    And match each response == productSchema

  @positive
  Scenario: Obtener un producto por id
    Given path 'products'
    When method GET
    Then status 200
    * def firstId = response[0].id
    Given path 'products', firstId
    When method GET
    Then status 200
    And match response == productSchema
    And match response.id == firstId

  @positive
  Scenario: Crear un producto valido
    * def created = call read('classpath:features/common/create-product.feature')
    * match created.product == productSchema
    * match created.product.title contains 'Producto QA'
    * match created.product.price == 150

  @positive
  Scenario: Actualizar un producto
    * def created = call read('classpath:features/common/create-product.feature')
    * def update = read('classpath:data/products/product-update.json')
    * set update.title = 'Producto QA actualizado ' + java.lang.System.currentTimeMillis()
    Given path 'products', created.product.id
    And request update
    When method PUT
    Then status 200
    And match response.title == update.title
    And match response.price == update.price

  @positive
  Scenario: Eliminar un producto
    * def created = call read('classpath:features/common/create-product.feature')
    Given path 'products', created.product.id
    When method DELETE
    Then status 200
    And match response == 'true'

  @negative
  Scenario: Consultar un producto inexistente
    Given path 'products', 999999
    When method GET
    Then status 400
    And match response.name == 'EntityNotFoundError'

  @negative
  Scenario: Crear un producto con datos invalidos
    * def invalid = read('classpath:data/products/product-invalid.json')
    Given path 'products'
    And request invalid
    When method POST
    Then status 400
    And match response.message contains 'title should not be empty'
    And match response.message contains 'price must be a positive number'


  @negative @known-bug
  Scenario: Actualizar un producto con body parcial
    * def created = call read('classpath:features/common/create-product.feature')
    Given path 'products', created.product.id
    And request { title: 'Solo titulo' }
    When method PUT
    Then status 400


@negative
Scenario: Consultar una ruta que no existe
  Given path 'ruta-que-no-existe'
  When method GET
  Then status 404
  And match response.statusCode == 404
  And match response.error == 'Not Found'
  And match response.message contains 'Cannot GET'


  @negative
  Scenario: Actualizar un producto con body parcial responde error de servidor
    # Defecto conocido: deberia responder 400, la API responde 500
    * def created = call read('classpath:features/common/create-product.feature')
    Given path 'products', created.product.id
    And request { title: 'Producto parcial', price: 250 }
    When method PUT
    Then status 500
    And match response.message == 'Internal server error'