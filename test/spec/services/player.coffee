'use strict'

describe 'Service: player', ->

  # load the service's module
  beforeEach module 'workorderInvasionApp'

  # instantiate service
  player = {}
  beforeEach inject (_player_) ->
    player = _player_

  it 'should do something', ->
    expect(!!player).toBe true
