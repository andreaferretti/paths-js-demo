define [
  'pajamas'
], (pj) ->
  base_url = 'https://api.github.com/repos/andreaferretti/paths-js-demo/contents'

  (path) ->
    pj(url: "#{ base_url }/#{ path }", dataType :'json').then (data) ->
      atob(data.content)