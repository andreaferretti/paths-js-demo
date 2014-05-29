requirejs.config
  baseUrl: './js'

  paths:
    'text' :      '../components/requirejs-text/text'
    'json' :      '../components/requirejs-plugins/src/json'
    'ractive':    '../components/ractive/ractive'
    'paths':      '../components/paths-js/dist/amd'
    'templates':  '../templates'
    'data':       '../data'

require ['app'], () -> return