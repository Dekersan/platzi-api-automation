@ignore
Feature: Crear usuario (reutilizable)

  Scenario: Crear usuario con email unico
    * def body = read('classpath:data/users/user-valid.json')
    * def email = 'qa.' + java.lang.System.currentTimeMillis() + '@example.com'
    * set body.email = email
    Given url baseUrl
    And path 'users'
    And request body
    When method POST
    Then status 201
    * def user = response