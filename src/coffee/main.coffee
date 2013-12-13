requirejs.config
	baseUrl: './js'

	paths:
		'text' : 		    '../components/requirejs-text/text'
		'domReady': 	  '../components/requirejs-domready/domReady'
		'ractive': 	    '../components/ractive/build/Ractive'
		'paths':        '../components/paths-js/dist/paths'
		'templates': 	  '../templates'

require ['views/pie', 'views/stock'], () ->
  console.log 'started'
