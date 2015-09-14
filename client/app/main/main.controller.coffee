'use strict'

angular.module 'beerflixAngularApp'
.controller 'MainCtrl', [ '$scope', '$http', 'socket', 'moviesService', ($scope, $http, socket, moviesService) ->
  $scope.awesomeThings = []
  
  $scope.pairs = []
  $scope.beers = []
  $scope.movies =[]
  
  $scope.recMovies = []
  $scope.flixList = []
  
  $scope.beerFind = ''
  $scope.movieFind = ''

  $http.get('/api/things').success (awesomeThings) =>
    $scope.awesomeThings = awesomeThings
    socket.syncUpdates 'thing', $scope.awesomeThings

  $http.get('/api/beer').success (pairs)=>
    console.log pairs
    $scope.pairs = pairs
    angular.forEach $scope.pairs, (val, key)->
      fetchFull = moviesService.findById(val.movies[0])
      fetchFull.then (data)->
        val.movieObject = data.data
    console.log $scope.pairs
  
  $scope.close = ->
    $scope.clearPair()
    $scope.$root.$broadcast 'closeDoors'
    $('#doors>div.hidden, button.hidden').removeClass 'hidden'
    $('.enter').show()
    return
  $scope.clearPair = ()->
    $scope.activeBeer = null
    $scope.activeMovie = null

  $scope.makePair = (beer, movie)->
    $http.post '/api/beer', 
      name: beer.name
      movies: [movie["imdbID"]]
      active: true
      beerId: beer.id
      img: beer.labels?.large
      desc: beer.description
    $('#doors>div').addClass 'hidden'
    $('.enter').hide(300);
    return

  $scope.addThing = ->
    return if $scope.newThing is ''
    $http.post '/api/things',
      name: $scope.newThing

    $scope.newThing = ''

  $scope.deleteThing = (thing) ->
    $http.delete '/api/things/' + thing._id

  $scope.$watch =>
    $scope.beerFind
  , (newVal, oldVal)=>
    # console.log newVal
    $scope.asyncFetchBeer(newVal)
  , true

  $scope.$watch =>
    $scope.movieFind
  , (newVal, oldVal)=>
    # console.log newVal
    $scope.asyncFetchMovie(newVal)
  , true

  $scope.asyncFetchBeer = _.debounce (val)=>
    if val
      brews = moviesService.searchBeer(val)
      brews.then (data)->
        $scope.beersList = data.data
  , 1000

  $scope.asyncFetchMovie = _.debounce (val)=>
    if val
      movies = moviesService.search(val)
      movies.then (data)->
        $scope.flixList = data.data["Search"]
  , 1000
  
  $scope.matchBeer = (beer)->
    console.log beer
    $scope.activeBeer = beer
    if beer.id
      findPairs = moviesService.findPairById(beer.id)
    if beer.beerId
      findPairs = moviesService.findPairById(beer.beerId)
    findPairs.then (pairs)->
      if pairs.data.length > 0
        console.log "pairs", pairs
        $scope.activeBeer.pairs = []
        angular.forEach pairs.data, (val)->
          console.log "looking up", val
          lookup = moviesService.findById(val.movies[0])
          lookup.then (data)->
            console.log "pushing", data
            $scope.activeBeer.pairs.push(data.data)
        console.log "scope pairs", $scope.activeBeer.pairs
        # $scope.activeBeer.pairs = pairs.data
    # movieLookup  = moviesService.search(beer.name)
    # movieLookup.then (movies)->
    #   $('#doors>div').addClass 'hidden'
    #   $scope.recMovies = movies.data["Search"]
    #   console.log $scope.recMovies
  $scope.enter = ->
    $('#doors>div, .enter').addClass 'hidden'
    $('.enter').hide(300);
    $('.pairs').removeClass 'hidden'
    return

  $scope.matchMovie = (movie)->
    console.log movie
    fetchFull = moviesService.findById(movie["imdbID"])
    fetchFull.then (data)->
      $scope.activeMovie = data.data

  $scope.activePair = (beer, movie)->
    console.log beer, movie
    $scope.matchBeer(beer);
    $scope.activeBeer = beer
    $scope.activeBeer.description = beer.desc
    $scope.activeBeer.labels = {}
    $scope.activeBeer.labels.large = beer.img
    $scope.activeMovie = movie
    $('body').animate({'scrollTop':'0px'}, 300);
    return

  $scope.movieSearch = (q)->
    flick = moviesService.search(q)
    flick.then (data)->
      console.log data
      $scope.movies = data.data["Search"]
      if $scope.movies.length > 0
        activeMovie = $scope.movies[Math.floor(Math.random() * ($scope.movies?.length-1))]
        myMovie = moviesService.findById(activeMovie["imdbID"])
        myMovie.then (data)->
          console.log 'myMovie', data
          $scope.activeMovie = data.data
    # $scope.beers = moviesService.search(q)
    # $scope.movies = moviesService.searchBeer(q)

    brew = moviesService.searchBeer(q)
    brew.then (data)->
      $scope.beers = data.data
      if $scope.beers.length > 0
        $scope.beers = $scope.beers.filter (obj)->
           console.log typeof obj.labels
           if typeof obj.labels == 'object'
              return true
           else
              return false
      $scope.activeBeer = $scope.beers[Math.floor(Math.random() * ($scope.beers?.length-1))]
  
  $scope.pair = (b, m)->
    $('#doors>div, .enter').addClass 'hidden'
    $('.enter').hide();
    return

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'thing'
]
