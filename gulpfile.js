var gulp = require('gulp');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var header = require('gulp-header');
var less = require('gulp-less');
var uglify = require('gulp-uglify');
var util = require('gulp-util');



gulp.task('js',function() {
  var creditText = [
    '/* Develope by : Kosate Limpongsa',
    ' * https://github.com/kosate/unpredictable',
    ' */'
  ].join('\n') + "\n";

  gulp.src('./src/private/*.coffee')
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .pipe(coffee())
    .on('error',function(){})
    .pipe(uglify())
    .pipe(header(creditText))
    .pipe(gulp.dest('./src/public/'));
});

gulp.task('css',function() {
  gulp.src('./src/private/*.less')
    .pipe(less())
    .pipe(gulp.dest('./src/public/'))
});

gulp.task('default',['js','css']);

gulp.task('watch',function() {
  gulp.watch(['./src/private/*.coffee'],['js']);
  gulp.watch(['./src/private/*.less'],['css']);
});
