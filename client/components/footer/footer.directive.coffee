'use strict'

angular.module 'beerflixAngularApp'
.directive 'footer', ->
  templateUrl: 'components/footer/footer.html'
  restrict: 'E',
  link: (scope, element) ->
    element.addClass('footer')
