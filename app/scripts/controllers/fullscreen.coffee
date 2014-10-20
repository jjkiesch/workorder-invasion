'use strict'

###*
 # @ngdoc function
 # @name workorderInvasionApp.controller:FullscreenCtrl
 # @description
 # # FullscreenCtrl
 # Controller of the workorderInvasionApp
###
angular.module('workorderInvasionApp')
  .controller 'FullscreenCtrl', ($scope) ->
    $scope.fullscreen = ->
      document.documentElement.webkitRequestFullscreen()
