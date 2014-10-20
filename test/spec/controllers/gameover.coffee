'use strict'

describe 'Controller: GameoverCtrl', ->

  # load the controller's module
  beforeEach module 'workorderInvasionApp'

  GameoverCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GameoverCtrl = $controller 'GameoverCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
