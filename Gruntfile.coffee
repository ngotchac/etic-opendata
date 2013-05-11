module.exports = (grunt) ->
  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'

    meta:
      dist:
        path: 'dist/'
      dev: 
        jspath: 'js/'
        csspath: 'css/'
        imgpath: 'img/'
      banner: '/*! <%= pkg.name %> v<%= pkg.version %> | <%= grunt.template.today("yyyy-mm-dd") %> */\n'

    watch:
      less:
        files: ['<%= meta.dev.csspath %>*.less']
        tasks: ['less:dev']
      coffee:
        files: ['<%= meta.dev.jspath %>*.coffee']
        tasks: ['coffee']

    coffee:
      files:
        src: '<%= meta.dev.jspath %><%= pkg.name %>.js'
        dest: '<%= meta.dev.jspath %><%= pkg.name %>.coffee'

    uglify: 
      dist: 
        options:
          banner: '<%= meta.banner %>'
          report: 'min'
        files:
          '<%= meta.dist.path %><%= pkg.name %>.min.js': ['<%= meta.dev.jspath %>*.js']

    less:
      options:
        paths: '<%= meta.dev.csspath %>'
      files: 
        expand: true
        cwd: '<%= meta.dev.csspath %>'
        src: ['*.less']
        dest: '<%= meta.dev.csspath %>'
        ext: '.css'
      

    cssmin:
      dist:
        options:
          banner: '<%= meta.banner %>'
          report: 'min'
        files:
          '<%= meta.dist.path %><%= pkg.name %>.min.css': ['<%= meta.dev.csspath %>/*.css']

    targethtml:
      dist:
          '<%= meta.dist.path %>index.html': 'index.html'

    copy:
      img:
        files: [
          expand: true
          cwd: '<%= meta.dev.imgpath %>'
          src: ['*']
          dest: '<%= meta.dist.path %><%= meta.dev.imgpath %>'
          filter: 'isFile'
        ]
      static: 
        files: [
          expand: true
          src: ['humans.txt', '404.html']
          dest: '<%= meta.dist.path %>'
        ]

    clean:
      dist: ['<%= meta.dist.path %>']
  }

  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-targethtml'

  grunt.registerTask 'dist', 'Compile and compress less and coffee files.', 
    ['clean:dist', 'less', 'cssmin', 'coffee', 'uglify', 'targethtml', 'copy']
  grunt.registerTask 'dev', 'Compile less and coffee files.', 
    ['less', 'coffee']
  grunt.registerTask 'default', 'dev'