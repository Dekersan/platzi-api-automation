@ignore
Feature: Crear producto (reutilizable)

  Scenario: Crear producto con titulo unico
    * def body = read('classpath:data/products/product-valid.json')
    * set body.title = 'Producto QA ' + java.lang.System.currentTimeMillis()
    Given url baseUrl
    And path 'products'
    And request body
    When method POST
    Then status 201
    * def product = response