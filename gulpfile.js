var gulp = require('gulp');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var header = require('gulp-header');
var less = require('gulp-less');
var uglify = require('gulp-uglify');
var minifyCss = require('gulp-minify-css');
var lessAutoPrefix = require('less-plugin-autoprefix');
var lessCleanCss = require('less-plugin-clean-css');

var isMin = false;

var creditText = [
  '/* Develope by : Kosate Limpongsa',
  ' * https://github.com/kosate/unpredictable',
  ' */'
].join('\n') + "\n";


gulp.task('js',function() {
  var tmp =
  gulp.src('./src/private/index.coffee')
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .pipe(coffee())
    .on('error',function(){});
  if( isMin )
    tmp.pipe(uglify());
  tmp
    .pipe(header(creditText))
    .pipe(gulp.dest('./src/public/'));
});

gulp.task('css',function() {
  var tmp = gulp.src('./src/private/index.less')
    .pipe(less())
    .on('error',function( err ){ console.log(err); });
  if( isMin )
    tmp
      .pipe(minifyCss())
      .pipe(header(creditText));
  else
    tmp.pipe(header(creditText));
  tmp.pipe(gulp.dest('./src/public/'));
});

gulp.task('build',function() {
  isMin = true;
  gulp.start( 'js','css' );
});

gulp.task('default',['js','css']);

gulp.task('watch',function() {
  gulp.watch(['./src/private/*.coffee'],['js']);
  gulp.watch(['./src/private/*.less'],['css']);
});
