define [
  'ractive'
  'palette/colors'
  'palette/util'
  'paths/radar'
  'text!templates/radar.html'
], (Ractive, Colors, util, Radar, template)->
  key_accessor = (keys) ->
    a = {}
    for key in keys
      ((k) -> (a[k] = (o) -> o[k]))(key)
    a

  pokemon = [
    { name: "Bulbasaur", hp: 45, attack: 49, defense: 49, sp_attack: 65, sp_defense: 65, speed: 45 }
#    { name: "Ivysaur", hp: 60, attack: 62, defense: 63, sp_attack: 80, sp_defense: 80, speed: 60 }
#    { name: "Venusaur", hp: 80, attack: 82, defense: 83, sp_attack: 100, sp_defense: 100, speed: 80 }
    { name: "Weedle", hp: 80, attack: 82, defense: 83, sp_attack: 100, sp_defense: 100, speed: 80 }
    { name: "Kakuna", hp: 45, attack: 25, defense: 50, sp_attack: 25, sp_defense: 25, speed: 35 }
  ]

  palette = Colors.mix {r: 130, g: 140, b: 210}, {r: 180, g: 205, b: 150}
  
  radar = new Ractive
    el: '#radar'
    template: template
    data:
      Radar: Radar
      center: [0, 0]
      r: 130
      accessor: key_accessor(['hp', 'attack', 'defense', 'sp_attack', 'sp_defense', 'speed'])
      data: pokemon
      colors: util.palette_to_function(palette)
      color_string: Colors.string