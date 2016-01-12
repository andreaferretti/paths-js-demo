define [
  'ractive'
  'show_source'
  'paths/sankey'
  'text!templates/sankey.html'
  'json!data/sankey.json'
], (Ractive, show_source, Sankey, template, data)->

  years = ['2010', '2011', '2012']
  palette = ["#707B82", "#7881C2", "#3E90F0"]

  sankey = new Ractive
    el: '#sankey'
    template: template
    data:
      data: data[0]
      years: years
      width: 500
      height: 400
      gutter: 15
      rectWidth: 10
      nodeaccessor: (x) -> x.id
      Sankey: Sankey
      index_: null
      start_: null
      end_: null
      firsthalf: (g) ->
        g < data[0].nodes.length / 2
      color: (g) ->
        palette[g]
      translate_rect: (r) ->
        [x, y] = r.centroid
        "translate(#{x},#{y})"
      opacity: (i, j) ->
        if j == null
          0.7
        else
          if j == i then 1 else 0.3
      opacity_rect: (item, start, end) ->
        if start == null
          0.7
        else
          if item.id == start or item.id == end then 1 else 0.3

  sankey.on "highlight", (event) ->
    @set
      'index_': event.context.index
      'start_': event.context.item.start
      'end_': event.context.item.end

  sankey.on "exit", (event) ->
    @set
      'index_': null
      'start_': null
      'end_': null

  sankey.observe 'year', (i) ->
    @animate 'data', data[parseInt(i)]

  show_source('sankey', sankey)