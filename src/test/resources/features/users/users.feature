@users
Feature: Servicio de usuarios

  Background:
    * url baseUrl
    * def userSchema = read('classpath:schemas/user-schema.json')

  @smoke @positive
  Scenario: Listar usuarios
    Given path 'users'
    When method GET
    Then status 200
    And match header Content-Type contains 'application/json'
    And match response == '#array'
    And match each response == userSchema

  @positive
  Scenario: Obtener un usuario por id
    Given path 'users', 1
    When method GET
    Then status 200
    And match response == userSchema
    And match response.id == 1

  @positive
  Scenario: Crear un usuario valido
    * def created = call read('classpath:features/common/create-user.feature')
    * match created.user == userSchema
    * match created.user.email == created.email

  @positive
  Scenario: Actualizar un usuario
    * def created = call read('classpath:features/common/create-user.feature')
    * def update = read('classpath:data/users/user-valid.json')
    * set update.name = 'Usuario QA actualizado'
    * set update.email = 'qa.upd.' + java.lang.System.currentTimeMillis() + '@example.com'
    Given path 'users', created.user.id
    And request update
    When method PUT
    Then status 200
    And match response.name == 'Usuario QA actualizado'

  @negative
  Scenario: Consultar un usuario inexistente
    Given path 'users', 999999
    When method GET
    Then status 400
    And match response.name == 'EntityNotFoundError'

  @negative
  Scenario: Crear un usuario con datos invalidos
    * def invalid = read('classpath:data/users/user-invalid.json')
    Given path 'users'
    And request invalid
    When method POST
    Then status 400
    And match response.message == '#array'
    And match response.message contains 'email must be an email'