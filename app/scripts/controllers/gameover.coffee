'use strict'

###*
 # @ngdoc function
 # @name workorderInvasionApp.controller:GameoverCtrl
 # @description
 # # GameoverCtrl
 # Controller of the workorderInvasionApp
###
angular.module('workorderInvasionApp')
  .controller 'GameoverCtrl', ($scope, player) ->
    $scope.score = player.getScore()
