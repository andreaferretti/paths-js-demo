define [
  'ractive'
  'show_source'
  'paths/waterfall'
  'text!templates/waterfall.html'
], (Ractive, show_source, Waterfall, template) ->

  months = ['January', 'February', 'March']

  profit = [
    [
      {
        name: 'Gross income',
        value: 30,
        absolute: true
      }
      {
        name: 'Transport',
        value: -6
      }
      {
        name: 'Distribution',
        value: -3
      }
      {
        name: 'Detail income'
        absolute: true
      }
      {
        name: 'Taxes',
        value: -8
      }
      {
        name: 'Net income'
        absolute: true
      }
    ]
    [
      {
        name: 'Gross income',
        value: 33,
        absolute: true
      }
      {
        name: 'Transport',
        value: -4
      }
      {
        name: 'Distribution',
        value: -5
      }
      {
        name: 'Detail income'
        absolute: true
      }
      {
        name: 'Taxes',
        value: -7
      }
      {
        name: 'Net income'
        absolute: true
      }
    ]
    [
      {
        name: 'Gross income',
        value: 40,
        absolute: true
      }
      {
        name: 'Transport',
        value: -3
      }
      {
        name: 'Distribution',
        value: -5
      }
      {
        name: 'Detail income'
        absolute: true
      }
      {
        name: 'Taxes',
        value: -4
      }
      {
        name: 'Net income'
        absolute: true
      }
    ]
  ]

  cycle = (arr, i) ->
    l = arr.length
    a = []
    for j in [0..l - 1]
      a[(j + i) % l] = arr[j]
    a

  waterfall = new Ractive
    el: '#waterfall'
    template: template
    data:
      Waterfall: Waterfall
      months: months
      profit: profit
      max: 40
      width: 460
      height: 350
      gutter: 10
      translate: (x) -> "translate(#{ x.centroid[0] },370)"
      color: (x) -> if x.absolute then "#acd1e9" else "#fa6078"

  waterfall.observe 'month', (i) ->
    @animate 'profit', cycle(profit, parseInt(i))

  show_source('waterfall', waterfall)