'use strict'

###*
 # @ngdoc overview
 # @name workorderInvasionApp
 # @description
 # # workorderInvasionApp
 #
 # Main module of the application.
###
angular
  .module('workorderInvasionApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/invasion',
        templateUrl: 'views/invasion.html'
        controller: 'InvasionCtrl'
      .when '/gameover',
        templateUrl: 'views/gameover.html'
        controller: 'GameoverCtrl'
      .when '/start',
        templateUrl: 'views/start.html'
        controller: 'StartCtrl'
      .when '/admin',
        templateUrl: 'views/admin.html'
        controller: 'AdminCtrl'
      .otherwise
        redirectTo: '/'

