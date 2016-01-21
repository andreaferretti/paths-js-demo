define [
  'ractive'
  'show_source'
  'paths/stack'
  'palette/util'
  'text!templates/stack.html'
], (Ractive, show_source, Stack, util, template)->
  palette = ["#FEE871", "#E5FAAF", "#B7E5F5"]
  colors = util.palette_to_function(palette)

  data = [
    [1, 2, 3, 4]
    [3, 5, 4, 2]
    [1, 6, 1, 6]
  ]

  lower = (data, index) ->
    data.map (d, i) ->
      if i == index then d else (0 for x in d)

  stack = new Ractive
    el: '#stack'
    template: template
    data:
      Stack: Stack
      data: data
      accessor: (x) -> x
      width: 500
      height: 350
      gutter: 10
      colors: colors

  stack.on 'detail', (event) ->
    index = event.context.group
    @animate 'data', lower(data, index)

  stack.on 'restore', ->
    @animate 'data', data

  show_source('stack', stack)