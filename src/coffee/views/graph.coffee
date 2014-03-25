define [
  'ractive'
  'paths/graph'
  'text!templates/graph.html'
], (Ractive, Graph, template)->

  nodes = [1..12]
  links = [
    { a: 1, b: 3, w: 5 }
    { a: 3, b: 4, w: 3 }
    { a: 5, b: 8, w: 6 }
    { a: 2, b: 1, w: 4 }
    { a: 7, b: 6, w: 4.3 }
    { a: 2, b: 10, w: 5.1 }
    { a: 10, b: 9, w: 8 }
    { a: 11, b: 4, w: 1.2 }
    { a: 8, b: 4, w: 6.9 }
    { a: 9, b: 12, w: 6.6 }
    { a: 4, b: 5, w: 5 }
    { a: 3, b: 7, w: 4.8 }
    { a: 1, b: 8, w: 5.6 }
    { a: 12, b: 6, w: 7.2 }
    { a: 6, b: 2, w: 3 }
    { a: 3, b: 11, w: 8.8 }
  ]

  get_link = ({a, b, w}) ->
    start: a
    end: b
    weight: w

  graph = Graph
    data:
      nodes: nodes
      links: links
    linkaccessor: get_link
    width: 600
    height: 300
    attraction: 0.003
    repulsion: 3000

  ractive = new Ractive
    el: '#graph'
    template: template
    data:
      graph: graph

  moving = true

  step = ->
    graph.tick()
    ractive.update()
    if moving then requestAnimationFrame(step)

  step()

  setTimeout (-> moving = false), 4000