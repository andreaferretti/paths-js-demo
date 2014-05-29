define [
  'ractive'
  'paths/graph'
  'palette/colors'
  'palette/util'
  'text!templates/graph.html'
], (Ractive, Graph, Colors, util, template) ->

  random_graph = (n, density) ->
    nodes = [0..n]
    links = []
    for i in [0..n-1]
      for j in [i+1..n]
        if Math.random() < density
          links.push
            start: i
            end: j
            weight: 3 + 5 * Math.random()

    nodes: nodes
    links: links

  palette = Colors.mix {r: 130, g: 140, b: 210}, {r: 180, g: 205, b: 150}

  graph = Graph
    data: random_graph(20, 0.25)
    width: 450
    height: 400
    attraction: 7
    repulsion: 20

  ractive = new Ractive
    el: '#graph'
    template: template
    data:
      graph: graph
      colors: util.palette_to_function(palette)
      color_string: Colors.string

  moving = true
  stop_time = 5
  svgX = null
  svgY = null
  following = null
  timer = null

  step = ->
    ractive.set(graph: graph.tick())
    if moving then requestAnimationFrame(step)

  start = ->
    if timer
      clearTimeout(timer)
      timer = null
    requestAnimationFrame(step)

  stop = ->
    timer = setTimeout (-> moving = false), 1000 * stop_time

  start()
  stop()


  ractive.on 'constrain', (event) ->
    moving = true
    target = event.original.target
    svgX = event.original.clientX - target.cx.baseVal.value
    svgY = event.original.clientY - target.cy.baseVal.value
    following = event.index.num
    start()

  ractive.on 'move', (event) ->
    if not following then return null
    if event.original.button != 0
      stop()
      return null
    coordinates = [event.original.clientX - svgX, event.original.clientY - svgY]
    graph.constrain(following, coordinates)

  ractive.on 'unconstrain', (event) ->
    graph.unconstrain(following)
    following = null
    stop()