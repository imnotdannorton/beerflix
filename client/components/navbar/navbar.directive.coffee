'use strict'

angular.module 'beerflixAngularApp'
.directive 'navbar', ->
  templateUrl: 'components/navbar/navbar.html'
  restrict: 'E'
  controller: 'NavbarCtrl'
