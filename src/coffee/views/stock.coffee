define [
  'ractive'
  'paths/stock'
  'text!templates/stock.html'
], (Ractive, Stock, template)->
  stock_data = [
    ["Jan 2000", 39.81]
    ["Feb 2000", 36.35]
    ["Mar 2000", 43.22]
    ["Apr 2000", 28.37]
    ["May 2000", 25.45]
    ["Jun 2000", 32.54]
    ["Jul 2000", 28.4]
    ["Aug 2000", 28.3]
  ]

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

  stock = new Ractive
    el: '#stock'
    template: template
    data:
      Stock: Stock
      data: stock_data
      xaccessor: ([x, y]) -> parse_date(x)
      width: 350
      height: 250
      closed: false