'use strict'

###*
 # @ngdoc function
 # @name workorderInvasionApp.controller:StartCtrl
 # @description
 # # StartCtrl
 # Controller of the workorderInvasionApp
###
angular.module('workorderInvasionApp')
  .controller 'StartCtrl', ($scope, player) ->
    $scope.play = ->
      player.savePlayer $scope.player
