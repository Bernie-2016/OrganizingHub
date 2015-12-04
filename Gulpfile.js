var gulp = require('gulp'),
    del = require('del'),
    sass = require('gulp-sass'),
    minifycss = require('gulp-minify-css'),
    coffee = require('gulp-coffee'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    jade = require('gulp-jade'),
    connect = require('gulp-connect');

gulp.task('clean', function() {
  return del([
    'dist/**/*'
  ]);
});

gulp.task('scss', function() {
  return gulp.src('scss/**/*.scss')
    .pipe(sass())
    .pipe(minifycss())
    .pipe(concat('production.min.css'))
    .pipe(gulp.dest('dist'))
});

gulp.task('coffee', function() {
  return gulp.src('coffee/**/*.coffee')
    .pipe(coffee())
    .pipe(uglify())
    .pipe(concat('production.min.js'))
    .pipe(gulp.dest('dist'))
});

gulp.task('jade', function() {
  return gulp.src('jade/pages/*.jade')
    .pipe(jade())
    .pipe(gulp.dest('dist'));
});

gulp.task('watch', function() {
  gulp.watch([
    'scss/**/*.scss',
    'coffee/**/*.coffee',
    'jade/**/*.jade'
  ], function(event) {
    gulp.src(event.path)
      .pipe(connect.reload());
  });

  gulp.watch('scss/**/*.scss', 'scss');
  gulp.watch('coffee/**/*.coffee', 'coffee');
  gulp.watch('jade/**/*.jade', 'jade');
});

gulp.task('connect', function() {
  connect.server({
    root: ['dist'],
    port: 9010,
    livereload: {
      port: 32834
    },
    connect: {
      redirect: false
    }
  });
});

gulp.task('default', ['clean', 'scss', 'coffee', 'jade']);
gulp.task('serve', ['default', 'connect', 'watch']);
