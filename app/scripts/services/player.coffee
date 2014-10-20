'use strict'

###*
 # @ngdoc service
 # @name workorderInvasionApp.player
 # @description
 # # player
 # Factory in the workorderInvasionApp.
###
angular.module('workorderInvasionApp')
  .factory 'player', ($location) ->
    # Service logic
    # ...

    prefix = 'player'
    current = ''

    # Public API here
    {
      savePlayer: (data) ->
        timestamp = Math.round(new Date().getTime())
        key = prefix + timestamp

        data = JSON.stringify(data)
        localStorage[key] = data
        current = key

        $location.path('/invasion')

      setScore: (score) ->
        player = localStorage[current]
        player = JSON.parse(player)
        player.score = score

        localStorage[current] = JSON.stringify(player)

      getScore: ->
        player = localStorage[current]
        player = JSON.parse(player)
        player.score

      getPlayer: ->
        unless current
          $location.path('/start')

      getPlayers: ->
        players = []
        prefixLength = prefix.length

        Object.keys(localStorage)
          .forEach (key) ->
            if key.substring(0, prefixLength) == prefix
              player = localStorage[key]
              console.log player
              player = JSON.parse(player)
              if player.score
                players.push(player)

        players
    }
