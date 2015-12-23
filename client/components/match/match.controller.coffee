'use strict'

angular.module 'beerflixAngularApp'
.controller 'MatchCtrl', [ '$scope', '$route', '$http', 'socket', 'matchesService', ($scope, $route, $http, socket, matchesService) ->
	# console.log $route.current.params.id
	$scope.id = $route.current.params.id
	
	$scope.matchMovie = (movieId)->
	    console.log movieId
	    fetchFull = matchesService.findById(movieId)
	    # activeMovie = null
	    # fetchFull.then (data)->
	    #   activeMovie = data.data
	    #   return activeMovie
	$scope.rateMatch = (index)->
		matchesService.update({id:$route.current.params.id, rating:index})
	
	$scope.$watch =>
		$route.current.params.id
	, (newVal, oldVal)->
		console.log newVal
		match = matchesService.fetchPair(newVal) 
		match.then (data)->
			$scope.activePair = data.data[0]
			console.log $scope.activePair.movies[0]
			movieFetch = matchesService.findById($scope.activePair.movies[0])
			movieFetch.then (movie)->
				$scope.activeMovie = movie.data

			$scope.moviesList = []
			movies = matchesService.findPairById($scope.activePair.beerId)
			movies.then (list)->
				angular.forEach list.data, (val, key)=>
					movie = matchesService.findById(val.movies[0])
					movie.then (result)->
						if $scope.moviesList.indexOf(result.data) is -1
							console.log result.data
							$scope.moviesList.push(result.data)
				console.log data, $scope.moviesList
		, (err)->
			console.log err
			
	, true

	

]