@ignore
Feature: Crear categoria (reutilizable)

  Scenario: Crear categoria con nombre unico
    * def body = read('classpath:data/categories/category-valid.json')
    * set body.name = 'Categoria QA ' + java.lang.System.currentTimeMillis()
    Given url baseUrl
    And path 'categories'
    And request body
    When method POST
    Then status 201
    * def category = response