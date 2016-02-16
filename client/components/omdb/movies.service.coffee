# global io

'use strict'

angular.module 'beerflixAngularApp'
.factory 'matchesService', ($http) ->
	endpoint = 'http://www.omdbapi.com/'
	constructor: ->
		console.log 'registered movie service'
	search: (query)->
		querystring = endpoint + '?s=' + query + '&y=&plot=full&r=json&max=10'
		$http.get(querystring)
	searchBeer: (query)->
		$http.get('/api/beer/'+query)
	findPairById: (id)->
		$http.get('api/beer/findbyid/'+id)
	fetchPair: (id)->
		$http.get('api/beer/fetchpair/'+id)
	find: (query)->
		querystring = endpoint + '?t=' + query + '&y=&plot=full&r=json&max=10'
		$http.get(querystring).success (data)->
			console.log data
	findById: (id)->
		querystring = endpoint + '?i=' + id + '&y=&plot=full&r=json&max=10'
		$http.get(querystring)
	update: (obj)->
		$http.post('/api/beer/update', obj)
        

