define [
  'ractive'
  'show_source'
  'palette/colors'
  'palette/util'
  'paths/pie'
  'text!templates/pie.html'
], (Ractive, show_source, Colors, util, Pie, template)->
  countries = [
    { name: 'Italy', population: 59859996 }
    { name: 'Mexico', population: 118395054 }
    { name: 'France', population: 65806000 }
    { name: 'Argentina', population: 40117096 }
    { name: 'Japan', population: 127290000 }
  ]

  palette = Colors.mix {r: 130, g: 140, b: 210}, {r: 180, g: 205, b: 150}

  pie = new Ractive
    el: '#pie'
    template: template
    data:
      Pie: Pie
      center: [0, 0]
      r: 60
      R: 140
      data: countries
      accessor: (x) -> x.population
      colors: util.palette_to_function(palette)
      expanded: [0, 0, 0, 0, 0]
      move: ([x, y], expanded) ->
        factor = expanded or 0
        "#{ factor * x / 3 }, #{ factor * y / 3 }"
      point: ([x, y]) -> "#{ x }, #{ y }"
      lighten: (color) ->
        Colors.string(Colors.lighten color)
      color_string: Colors.string

  pie.on 'expand', (event) ->
    index = event.index.num
    target = [0, 0, 0, 0, 0]
    target[index] = 1
    @animate 'expanded', target, easing: 'easeOut'

  show_source('pie', pie)