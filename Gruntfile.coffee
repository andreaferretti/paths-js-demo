module.exports = (grunt)->

  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-compass')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-htmlmin')
  grunt.loadNpmTasks('grunt-contrib-imagemin')
  grunt.loadNpmTasks('grunt-contrib-requirejs')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-open')
  grunt.loadNpmTasks('grunt-usemin')
  grunt.loadNpmTasks('grunt-mocha')

  mountFolder = (connect, dir)->
    return connect.static(require('path').resolve(dir))

  config =
    app: 'app'
    src: 'src'
    dist: 'dist'
    test: 'test'

    tmp: '.tmp'
    tmp_dist: '.tmp-dist'

    server_port: 9000
    livereload_port: 35729

  grunt.initConfig
    config: config

    watch:
      options:
        interrupt: true

      coffee:
        files: ['<%= config.src %>/coffee/{,**/}*.coffee']
        tasks: ['coffee:dist']
      
      compass:
        files: ['<%= config.src %>/sass/{,**/}*.{scss,sass}']
        tasks: ['compass:server']
      
      files:
        files: [
          '<%= config.tmp %>/{,**/}*.{css,js}'
          '<%= config.app %>/{,**/}*.html'
          '<%= config.app %>/css/{,**/}*.css'
          '<%= config.app %>/js/{,**/}*.js'
          '<%= config.app %>/images/{,**/}*.{png,jpg,jpeg}'
          '!<%= config.app %>/components/**'
        ]
        tasks: []
        options:
          livereload: config.livereload_port

    connect:
      server:
        options:
          port: config.server_port
          hostname: '0.0.0.0'
          middleware: (connect)->
            return [
              require('connect-livereload')(port: config.livereload_port)
              mountFolder(connect, config.tmp)
              mountFolder(connect, config.app)
            ]

    open:
      server:
        path: 'http://localhost:<%= connect.server.options.port %>'
      dist:
        path: 'http://localhost:<%= connect.dist.options.port %>'
      test:
        path: 'http://localhost:<%= connect.test.options.port %>'

    clean:
      dist: ['<%= config.dist %>']
      tmp: ['<%= config.tmp %>']
      tmp_dist: ['<%= config.tmp_dist %>']
      components: ['<%= config.dist %>/components']
      templates: ['<%= config.dist %>/templates']

    coffee:
      dist:
        expand: true
        cwd: 'src/coffee/'
        src: ['**/*.coffee']
        dest: '<%= config.tmp %>/js'
        ext: '.js'

    compass:
      options:
        sassDir: '<%= config.src %>/sass'
        cssDir: '<%= config.tmp %>/css'
        imagesDir: '<%= config.app %>/images'
        javascriptsDir: '<%= config.app %>/js'
        fontsDir: './css/fonts'
        importPath: ['<%= config.app %>/components']
        relativeAssets: true

      dist: 
        options:
          force: true
          outputStyle: 'compressed'
          environment: 'production'
      server:
        options:
          debugInfo: true

    copy:
      dist:
        files: [
          { expand: true, cwd: '<%= config.tmp %>/', src: ['**'], dest: '<%= config.tmp_dist %>/' }
          { expand: true, cwd: '<%= config.app %>/', src: ['**'], dest: '<%= config.tmp_dist %>/' }
        ]

    useminPrepare:
      html: '<%= config.tmp_dist %>/index.html'
      options:
        dest: '<%= config.dist %>'

    usemin:
      html: ['<%= config.dist %>/{,*/}*.html']
      css: ['<%= config.dist %>/css/{,*/}*.css']
      options:
        dirs: ['<%= config.dist %>']

    imagemin:
      dist:
        files: [{
          expand: true,
          cwd: '<%= config.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg}'
          dest: '<%= config.dist %>/images'
        }]

    htmlmin:
      dist:
        files: [{
          expand: true,
          cwd: '<%= config.app %>',
          src: ['*.html', 'templates/*.html'],
          dest: '<%= config.dist %>'
        }]

    requirejs:
      compile:
        options:
          # no minification, is done by the min task
          baseUrl: 'js/'
          appDir: './<%= config.tmp_dist %>/'
          dir: './<%= config.dist %>/'
          
          skipDirOptimize: true
          wrap: true

          removeCombined: true
          keepBuildDir: true

          inlineText: true
          mainConfigFile: '<%= config.tmp_dist %>/js/main.js'

          optimize: "uglify"

  
  grunt.registerTask('server', [
    'coffee:dist'
    'compass:server'
    'connect:server'
    'open:server'
    'watch'
  ])


  grunt.registerTask('compile', [
    'coffee:dist'
    'compass:server'
  ])

  grunt.registerTask('build', [
    'clean:dist'
    'clean:tmp'
    'clean:tmp_dist'
    'coffee'
    'compass:dist'
    'copy:dist'
    'requirejs:compile'
    'useminPrepare'
    'imagemin'
    'htmlmin'
    'concat'
    'usemin'
    'clean:tmp_dist'
    'clean:components'
    'clean:templates'
  ])

  grunt.registerTask('default', ['build'])
