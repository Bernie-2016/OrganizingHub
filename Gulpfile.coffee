gulp      = require('gulp')
gulpif    = require('gulp-if')
del       = require('del')
sass      = require('gulp-sass')
minifycss = require('gulp-minify-css')
coffee    = require('gulp-coffee')
uglify    = require('gulp-uglify')
concat    = require('gulp-concat')
jade      = require('gulp-jade')
copy      = require('gulp-copy')
connect   = require('gulp-connect')

gulp.task 'clean', ->
  del(['dist/**/*'])

gulp.task 'scss', ->
  gulp.src('scss/index.scss')
    .pipe(sass(includePaths: ['node_modules/zurb-foundation-5/scss']))
    .pipe(concat('production.min.css'))
    .pipe(minifycss())
    .pipe(gulp.dest('dist'))

gulp.task 'coffee', ->
  gulp.src([
    'node_modules/jquery/dist/jquery.js'
    'node_modules/fastclick/lib/fastclick.js'
    'node_modules/zurb-foundation-5/js/foundation/foundation.js'
    'coffee/**/*.coffee'
  ])
  .pipe(gulpif(/[.]coffee$/, coffee()))
  .pipe(uglify())
  .pipe(concat('production.min.js'))
  .pipe(gulp.dest('dist'))

gulp.task 'jade', ->
  gulp.src('jade/pages/*.jade')
    .pipe(jade())
    .pipe(gulp.dest('dist'))

gulp.task 'copy', ->
  gulp.src([
    'fonts/*'
    'img/*'
  ]).pipe(copy('dist'))

gulp.task 'watch', ->
  gulp.watch [
    'scss/**/*.scss'
    'coffee/**/*.coffee'
    'jade/**/*.jade'
  ], (event) ->
    gulp.src(event.path).pipe connect.reload()

  gulp.watch 'scss/**/*.scss', ['scss']
  gulp.watch 'coffee/**/*.coffee', ['coffee']
  gulp.watch 'jade/**/*.jade', ['jade']

gulp.task 'connect', ->
  connect.server
    root: ['dist']
    port: 9010
    livereload:
      port: 32834
    connect:
      redirect: false

gulp.task 'default', [
  'clean'
  'scss'
  'coffee'
  'jade'
  'copy'
]

gulp.task 'serve', [
  'default'
  'connect'
  'watch'
]
