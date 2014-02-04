define [
  'ractive'
  'paths/bar'
  'palette/util'
  'text!templates/bar.html'
], (Ractive, Bar, util, template)->
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

  bar = new Ractive
    el: '#bar'
    template: template
    data:
      Bar: Bar
      data: data
      accessor: (x) -> x
      width: 500
      height: 350
      gutter: 10
      colors: colors

  bar.on 'detail', (event) ->
    index = event.index.num % 3
    @animate 'data', lower(data, index)

  bar.on 'restore', ->
    @animate 'data', data