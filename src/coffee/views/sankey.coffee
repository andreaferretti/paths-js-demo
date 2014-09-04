define [
  'ractive'
  'show_source'
  './sankey_'
  'palette/util'
  'text!templates/sankey.html'
  'paths/curved-rectangle'
  'paths/rectangle'
], (Ractive, show_source, sankey, util, template, CurverdRectangle, Rectangle)->
  coords = []
  height = 380
  width = 500
  rect_width = 10

  gutter = 20

  data = {
      nodes:[
        ["pippo","pluto","paperino"],
        ["qui","quo","qua"],
        ["nonna papera","ciccio"]
      ]
      links:[
        {start:"pippo",end:"quo",weight:10}
        {start:"pippo",end:"qua",weight:30}
        {start:"pluto",end:"nonna papera",weight:10}
        {start:"pluto",end:"qui",weight:10}
        {start:"pluto",end:"quo",weight:10}
        {start:"paperino",end:"ciccio",weight:100}
        {start:"qui", end:"ciccio", weight: 20}
        {start:"quo", end:"ciccio", weight: 10}
        {start:"qua", end:"nonna papera", weight: 30}
      ]
    }

  #compute the spacing between groups of rectangles; takes care of rects width
  spacing_groups = (width - rect_width)/(data.nodes.length - 1)
  
  name_values = {}

  #initialize the informations about nodes
  data.nodes.reduce((a,b) -> a.concat b).forEach((name) ->
    name_values[name] = {
      value: 0
      currently_used_in: 0
      currently_used_out: 0
    }
  )

  for name of name_values
    vals_in = data.links.filter((x) -> x.end == name).map((x) -> x["weight"]).reduce(((x,y) -> x + y), 0)
    vals_out = data.links.filter((x) -> x.start == name).map((x) -> x["weight"]).reduce(((x,y) -> x + y), 0)
    name_values[name]["value"] = Math.max(vals_in,vals_out)

  #find a suitable scale: it should take care of the maximum height of stacked rectangles and gutters between them
  #I did as follows: take the initial height and, for each group of rectangles
  # compute how much space you have available, that is height - gutters; there are
  # length_of_group - 1 gutters. Consider the ratios space_for_each_group/height_of_stacked_rectangles
  # and take the minimum. Use this as scale factor.

  #compute height of staked rectangles in a group
  height_of_groups = data.nodes.map((group) ->
    group.map((name) -> 
      name_values[name]["value"]).reduce((x,y) -> x + y)
  )

  #compute the available height for each group (height - gutters)
  space_for_each_group = data.nodes.map((group) ->
    height - (group.length - 1)*gutter
  )

  #compute minimum ratio
  scale = height_of_groups.map((height_of_group, idx) ->
    space_for_each_group[idx]/height_of_group
  ).reduce((x,y) -> Math.min(x,y))

  for name, val of name_values
    console.log val, scale*val["value"]
    name_values[name]["scaled_value"] = scale*val["value"]

  #fill rectangles information: each rectangle is stack on the previous one, with a gutter
  # the group of rectangles is centered in their own column
  data.nodes.forEach((group, idx) ->
    h_group = group.reduce(((x,y) -> x + name_values[y]["scaled_value"]), 0) + (group.length - 1)*gutter
    vertical_spacing = (height - h_group)/2
    first_top = vertical_spacing
    #fake previous bottom
    previous_bottom = first_top - gutter
    group.forEach((name) ->
      top = previous_bottom + gutter
      bottom = top + name_values[name]["scaled_value"]
      previous_bottom = bottom
      name_values[name]["rectangle_coords"] = {
        top: top
        bottom: bottom
        left: rect_width/2 + idx*spacing_groups - rect_width/2
        right: rect_width/2 + idx*spacing_groups + rect_width/2
      }
    )
  )

  rects = []

  for name, atts of name_values
    rects.push(Rectangle(atts["rectangle_coords"]))
  

  console.log name_values

  curved_rects = data.links.map((link) -> 
    source = link["start"]
    target = link["end"]
    rect_source = name_values[source]["rectangle_coords"]
    rect_target = name_values[target]["rectangle_coords"]
    scaled_weight = link["weight"]*scale
    a = rect_source["top"] + name_values[source]["currently_used_out"]
    b = rect_target["top"] + name_values[target]["currently_used_in"]
    curved_rect = {
      topleft: [rect_source["right"],a]
      topright: [rect_target["left"],b]
      bottomleft: [rect_source["right"],a+scaled_weight]
      bottomright: [rect_target["left"],b+scaled_weight]
      # topleft: [rect_source["right"], rect_source["top"] + name_values[source]["currently_used_out"]]
      # topright: [rect_target["left"], rect_target["top"] + name_values[target]["currently_used_in"]]
      # bottomleft: [rect_source["right"], rect_source["top"] + name_values[source]["currently_used_out"] + scaled_weight]
      # bottomright: [rect_target["left"], rect_source["top"] + name_values[target]["currently_used_in"] + scaled_weight]
    }
    name_values[source]["currently_used_out"] = name_values[source]["currently_used_out"] + scaled_weight
    name_values[target]["currently_used_in"] = name_values[target]["currently_used_in"] + scaled_weight
    CurverdRectangle(curved_rect)
  )

  # console.log curved_rects

  sankey = new Ractive
    el: '#sankey'
    template: template
    data:
      listOfPoints: coords
      Shapes: "hi"
      curvedRectangles: curved_rects
      rectangles: rects

  # show_source('curvedrect', curvedrect)