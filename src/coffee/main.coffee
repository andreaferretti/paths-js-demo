requirejs.config
  baseUrl: './js'

  paths:
    'text' :                      '../components/requirejs-text/text'
    'json' :                      '../components/requirejs-plugins/src/json'
    'ractive':                    '../components/ractive/build/Ractive'
    'q':                          '../components/q/q'
    'pajamas':                    '../components/pajamas/dist/pajamas'
    'highlight':                  '../components/highlight/src/highlight'
    'paths':                      '../components/paths-js/dist/amd'
    'templates':                  '../templates'
    'data':                       '../data'

require ['app'], () -> return