define [
  'ractive'
  'paths/waterfall'
  'text!templates/waterfall.html'
], (Ractive, Waterfall, template) ->

  data = [
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

  waterfall = new Ractive
    el: '#waterfall'
    template: template
    data:
      Waterfall: Waterfall
      data: data
      width: 460
      height: 350
      gutter: 10
      translate: (x) -> "translate(#{ x.centroid[0] },370)"
      color: (x) -> if x.absolute then "#acd1e9" else "#fa6078"