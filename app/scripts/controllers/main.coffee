'use strict'

###*
 # @ngdoc function
 # @name workorderInvasionApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the workorderInvasionApp
###
angular.module('workorderInvasionApp')
  .controller 'MainCtrl', ($scope, $location, player) ->
    $scope.players = player.getPlayers()
