'use strict'

angular.module 'beerflixAngularApp'
.controller 'MainCtrl', [ '$scope', '$http', '$location', 'socket', 'matchesService', ($scope, $http, $location, socket, matchesService) ->
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
      fetchFull = matchesService.findById(val.movies[0])
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
    findPairs = matchesService.findPairById(beer.id)
    findPairs.then (pairs)->
      if pairs.data.length > 0
        console.log 'dupe' 
        # $http.post '/api/beer/delete',
        #   id:  pairs.data[0]._id
        $http.post '/api/beer/update',
          id:  pairs.data[0]._id
          movies: [movie["imdbID"]].concat(pairs.data[0].movies)
      else 
        $http.post '/api/beer', 
          name: beer.name
          movies: [movie["imdbID"]]
          active: true
          beerId: beer.id
          img: beer.labels?.large
          desc: beer.description
    $('#doors>div').addClass 'hidden'
    $('.pairs.hidden').removeClass 'hidden'
    $('.enter').hide(300);
    return

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
      brews = matchesService.searchBeer(val)
      brews.then (data)->
        $scope.beersList = data.data
  , 1000

  $scope.asyncFetchMovie = _.debounce (val)=>
    if val
      movies = matchesService.search(val)
      movies.then (data)->
        $scope.flixList = data.data["Search"]
  , 1000
  
  $scope.matchBeer = (beer)->
    console.log beer
    $scope.activeBeer = beer
    id =  ""
    if beer.id
      findPairs = matchesService.findPairById(beer.id)
      id = beer.id
    if beer.beerId
      console.log "fetching by beerId"
      findPairs = matchesService.findPairById(beer.beerId)
      id = beer.beerId
    findPairs.then (pairs)->
      if pairs.data.length > 0
        console.log "pairs", pairs
        $scope.activeBeer.pairs = []
        angular.forEach pairs.data, (val)->
          console.log "looking up", val
          lookup = matchesService.findById(val.movies[0])
          lookup.then (data)->
            console.log "pushing", data
            $scope.activeBeer.pairs.push(data.data)
        console.log "scope pairs", $scope.activeBeer.pairs
        # $scope.activeBeer.pairs = pairs.data
    # movieLookup  = matchesService.search(beer.name)
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
    fetchFull = matchesService.findById(movie["imdbID"])
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
    flick = matchesService.search(q)
    flick.then (data)->
      console.log data
      $scope.movies = data.data["Search"]
      if $scope.movies.length > 0
        activeMovie = $scope.movies[Math.floor(Math.random() * ($scope.movies?.length-1))]
        myMovie = matchesService.findById(activeMovie["imdbID"])
        myMovie.then (data)->
          console.log 'myMovie', data
          $scope.activeMovie = data.data
    # $scope.beers = matchesService.search(q)
    # $scope.movies = matchesService.searchBeer(q)

    brew = matchesService.searchBeer(q)
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
    $('.pairs').removeClass 'hidden'
    return

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'thing'
]
