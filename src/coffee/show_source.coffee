define [
  'views/overlay'
], (overlay) ->

  (view, ractive) ->
    ractive.on 'coffee', ->
      overlay
        lang: 'coffeescript'
        title: 'Coffeescript'
        path: "src/coffee/views/#{ view }.coffee"

    ractive.on 'html', ->
      overlay
        lang: 'html'
        title: 'HTML'
        path: "app/templates/#{ view }.html"