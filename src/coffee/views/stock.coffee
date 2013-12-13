define [
  'ractive'
  'paths/stock'
  'palette/util'
  'json!data/stock.json'
  'text!templates/stock.html'
], (Ractive, Stock, util, stock_data, template)->
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

  palette = ["#707B82", "#3E90F0", "#7881C2"]

  stock = new Ractive
    el: '#stock'
    template: template
    data:
      Stock: Stock
      data: [stock_data.MSFT, stock_data.AAPL, stock_data.AMZN]
      xaccessor: ({ date }) -> parse_date(date)
      yaccessor: ({ value }) -> value
      width: 500
      height: 350
      colors: util.palette_to_function(palette)
      closed: false