'use strict'

###*
 # @ngdoc function
 # @name workorderInvasionApp.controller:AdminCtrl
 # @description
 # # AdminCtrl
 # Controller of the workorderInvasionApp
###
angular.module('workorderInvasionApp')
  .controller 'AdminCtrl', ($scope, player) ->
    $scope.players = 'Name,Email,State,Accepted,Score\n'

    for player in player.getPlayers()
      line = ''

      for key, value of player
        if key != 'score'
          console.log key, 'not score'
          line += value + ','
        else
          console.log key
          line += value

      line += '\n'
      $scope.players += line
