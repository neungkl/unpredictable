$ ->
  canvas = $('canvas')
  paper.setup( canvas )
  path = new paper.Path()
  path.moveTo( new paper.Point(100,100) )
  path.lineTo( new paper.Point(200,200) )
  paper.view.draw()
