'use strict'

describe 'Controller: FullscreenCtrl', ->

  # load the controller's module
  beforeEach module 'workorderInvasionApp'

  FullscreenCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FullscreenCtrl = $controller 'FullscreenCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
