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
    for i in nodes
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
  frames = 0

  step = ->
    frames +=1
    ractive.set(graph: graph.tick())
    if moving then requestAnimationFrame(step)

  step()

  setTimeout (-> moving = false; console.log("fps", frames / stop_time)), 1000 * stop_time