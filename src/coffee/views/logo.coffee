define [
  'ractive'
  'paths/bezier'
  'text!templates/logo.html'
], (Ractive, Bezier, template)->
  points = [
    [0, 50]
    [50, 70]
    [100, 40]
    [150, 30]
    [200, 60]
    [250, 80]
    [300, 50]
  ]

  move = (ps) ->
    ps.map ([x, y]) -> [x, y - 25 + 50 * Math.random()]

  Ractive.easing.elastic = (pos) ->
    -1 * Math.pow(4,-8 * pos) * Math.sin((pos * 6 - 1) * (2 * Math.PI) / 2) + 1


  logo = new Ractive
    el: '#logo'
    template: template
    data:
      Bezier: Bezier
      points: points
      name: ([x, y]) -> {x: x, y: y}

  go_back = ->
    logo.animate 'points', points, easing: 'elastic'

  logo.on 'shuffle', (event) ->
    @animate 'points', move(points),
      easing: 'easeIn'
      complete: go_back