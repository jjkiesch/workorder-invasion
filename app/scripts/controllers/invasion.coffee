'use strict'

###*
 # @ngdoc function
 # @name workorderInvasionApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the workorderInvasionApp
###
angular.module('workorderInvasionApp')
  .controller 'InvasionCtrl', ($scope, player, $location) ->
    Game.init()

    player.getPlayer()

    $scope.setScore = (score) ->
      player.setScore(score)
