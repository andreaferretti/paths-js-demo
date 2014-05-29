define [
  'ractive'
  'git_source'
  'text!templates/overlay.html'
], (Ractive, git_source, template)->

  overlay = new Ractive
    el: '#overlay'
    template: template
    data:
      visible: false
      title: null
      body: null

  overlay.on 'close', ->
    @set
      visible: false
      title: null
      body: null

  ({ title, lang, path }) ->
    git_source(path).then (body) ->
      overlay.set
        visible: true
        title: title
        body: hljs.highlight(lang, body).value