@filters
Feature: Filtrar productos

  Background:
    * url baseUrl
    * def productSchema = read('classpath:schemas/product-schema.json')

  @smoke @positive
  Scenario: Filtrar por titulo
    * def created = call read('classpath:features/common/create-product.feature')
    Given path 'products'
    And param title = created.product.title
    When method GET
    Then status 200
    And assert response.length > 0
    And match each response == productSchema
    And match response[0].title == created.product.title

  @positive
  Scenario: Filtrar por rango de precio
    * def created = call read('classpath:features/common/create-product.feature')
    Given path 'products'
    And param price_min = 100
    And param price_max = 200
    When method GET
    Then status 200
    And assert response.length > 0
    And match each response[*].price == '#? _ >= 100 && _ <= 200'

  @positive
  Scenario: Filtrar por categoria
    Given path 'products'
    And param categoryId = 1
    When method GET
    Then status 200
    And match each response[*].category.id == 1

  @positive
  Scenario: Paginar con limit y offset
    Given path 'products'
    And param limit = 3
    And param offset = 0
    When method GET
    Then status 200
    And match response == '#[3]'

  @negative
  Scenario: Rango de precio invertido
    Given path 'products'
    And param price_min = 1000
    And param price_max = 10
    When method GET
    Then status 200
    And match response == []