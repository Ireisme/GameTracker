angular.module('BoardgameTracker')
.controller 'GamesAddCtrl', ['$scope', '$stateParams', '$state', 'GamesService', ($scope, $stateParams, $state, GamesService) ->
  GamesService.New()
  .then (data) ->
    $scope.game = data

  $scope.add = -> 
  	GamesService.Add($scope.game)
    .then (data) -> 
      $state.go('home.games.view', { id: data })
      return
  $scope.cancel = ->
    $state.go('home.games.all')
    return
  ]