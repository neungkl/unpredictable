for i in [0..9]
  for j in [0..9]
    obj = new Shape.Rectangle(
      new Point( (i*60), (j*60) ),
      new Size( 56,56 )
    )
    obj.strokeColor = 'black'

view.viewSize = new Size( 600,600 )
view.draw()
