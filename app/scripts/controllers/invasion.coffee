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
    $scope.secondsTilStart = 5

    $scope.gameReady = ->
      if $scope.secondsTilStart == 0
        true
      else
        false

    countdownTimer = window.setInterval ->
      $scope.$apply ->
        $scope.secondsTilStart--
      if $scope.secondsTilStart == 0
        window.clearInterval countdownTimer
        Game.init()
    , 1000

    player.getPlayer()

    $scope.setScore = (score) ->
      player.setScore(score)
