# global io

'use strict'

angular.module 'beerflixAngularApp'
.factory 'moviesService', ($http) ->
	endpoint = 'http://www.omdbapi.com/'
	constructor: ->
		console.log 'registered movie service'
	search: (query)->
		querystring = endpoint + '?s=' + query + '&y=&plot=full&r=json&max=10'
		$http.get(querystring)
	searchBeer: (query)->
		$http.get('/api/beer/'+query)
	find: (query)->
		querystring = endpoint + '?t=' + query + '&y=&plot=full&r=json&max=10'
		$http.get(querystring).success (data)->
			console.log data
	findById: (id)->
		querystring = endpoint + '?i=' + id + '&y=&plot=full&r=json&max=10'
		$http.get(querystring)

