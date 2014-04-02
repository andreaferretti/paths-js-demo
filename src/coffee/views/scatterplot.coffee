define [
  'ractive'
  'paths/stock'
  'palette/util'
  'json!data/twin-peaks.json'
  'text!templates/scatterplot.html'
], (Ractive, Stock, util, tp, template)->

  palette = ["#3E90F0", "#7881C2", "#707B82"]
  colors = util.palette_to_function(palette)

  scatterplot = new Ractive
    el: '#scatterplot'
    template: template
    data:
      Stock: Stock
      data: [tp]
      xaccessor: ({ episode }) -> episode
      yaccessor: ({ rating }) -> rating
      width: 460
      height: 350
      colors: colors
      translate: ([x, y]) -> "translate(#{x},#{y})"

  scatterplot.on 'enter', (event) ->
    { num, count } = event.index
    tp[count].selected = true
    @update()

  scatterplot.on 'leave', (event) ->
    { num, count } = event.index
    tp[count].selected = false
    @update()