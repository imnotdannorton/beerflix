'use strict'

angular.module 'beerflixAngularApp'
.config ($routeProvider) ->
  $routeProvider
  .when '/',
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
  .when '/all',
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
  .when '/match/:id',
  	templateUrl:'components/match/match.html'
  	controller: 'MatchCtrl'

