'use strict'

angular.module('beerflixAngularApp').directive 'door', ->
  {
    restrict: 'AC'
    link: (scope, element) ->
      element.on 'click', ->
        $('#doors>div').addClass 'hidden'
        return
      return
  }