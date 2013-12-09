define [], ()->
  cut = (x) ->
    Math.min(255, Math.floor(x))
  
  multiply = (factor) -> (c) ->
    r: cut(factor * c.r)
    g: cut(factor * c.g)
    b: cut(factor * c.b)
  
  average = (c1, c2) ->
    r: cut((c1.r + c2.r) / 2)
    g: cut((c1.g + c2.g) / 2)
    b: cut((c1.b + c2.b) / 2)
  
  lighten = multiply(0.8)
  darken = multiply(1.2)
    
  mix = (c1, c2) ->
    c3 = average c1, c2
    [
      lighten c1
      c1
      darken c1
      lighten c3
      c3
      darken c3
      lighten c2
      c2
      darken c2
    ]
    
  multiply: multiply
  average: average
  lighten: lighten
  darken: darken
  mix: mix
