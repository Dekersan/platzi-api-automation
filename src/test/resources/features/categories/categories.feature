@categories
Feature: Servicio de categorias

  Background:
    * url baseUrl
    * def categorySchema = read('classpath:schemas/category-schema.json')

  @smoke @positive
  Scenario: Listar categorias
    Given path 'categories'
    When method GET
    Then status 200
    And match response == '#array'

  @positive
  Scenario: Obtener una categoria por id
    Given path 'categories', 1
    When method GET
    Then status 200
    And match response == categorySchema
    And match response.id == 1

  @positive
  Scenario: Crear una categoria valida
    * def created = call read('classpath:features/common/create-category.feature')
    * match created.category == categorySchema
    * match created.category.name contains 'Categoria QA'

  @negative
  Scenario: Consultar una categoria inexistente
    Given path 'categories', 999999
    When method GET
    Then status 400
    And match response.name == 'EntityNotFoundError'

  @negative
  Scenario: Crear una categoria con datos invalidos
    * def invalid = read('classpath:data/categories/category-invalid.json')
    Given path 'categories'
    And request invalid
    When method POST
    Then status 400
    And match response.statusCode == 400
    And match response.error == 'Bad Request'
    And match response.message contains 'name should not be empty'