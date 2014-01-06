define [
  'ractive'
  'paths/smooth-line'
  'palette/util'
  'json!data/stock.json'
  'text!templates/line.html'
], (Ractive, SmoothLine, util, stock_data, template)->
  parse_date = (str) ->
    [month, year] = str.split ' '
    months =
      Jan: 0
      Feb: 1
      Mar: 2
      Apr: 3
      May: 4
      Jun: 5
      Jul: 6
      Aug: 7
      Sep: 8
      Oct: 9
      Nov: 10
      Dec: 11

    m = months[month]
    d = new Date()
    d.setMonth(m)
    d.setYear(parseInt(year, 10) - 1900)
    d.getTime()

  palette = ["#3E90F0", "#7881C2", "#707B82"]
  colors = util.palette_to_function(palette)
  stocks = ['MSFT', 'AAPL', 'AMZN']
  stock_array = [stock_data.MSFT, stock_data.AAPL, stock_data.AMZN]

  cycle = (arr, i) ->
    l = arr.length
    a = []
    for j in [0..l - 1]
      a[(j + i) % l] = arr[j]
    a

  line = new Ractive
    el: '#line'
    template: template
    data:
      Line: SmoothLine
      data: stock_array
      xaccessor: ({ date }) -> parse_date(date)
      yaccessor: ({ value }) -> value
      width: 500
      height: 350
      stocks: stocks
      colors: colors
      closed: false

  line.observe 'stock', (i) ->
    if i == 'all'
      @set
        data: stock_array
        colors: colors
    else
      @animate 'data', cycle(stock_array, parseInt(i))
      @set 'colors', util.palette_to_function(cycle(palette, parseInt(i)))