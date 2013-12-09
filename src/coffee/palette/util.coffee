define [], ()->
  palette_to_function: (palette) -> (i) ->
    palette[i % palette.length]
