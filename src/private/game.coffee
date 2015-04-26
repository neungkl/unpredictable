log = (x) -> console.log x

window.game = do ->
  ret = {}
  GameSize = -1
  Board = []
  traveled = []
  obj =
    itr : new Group()
    board : new Group()
  refreshTime = 0
  gameStatus = 'None'
  startTime = 0
  unableToPause = true
  curr = {}
  conf =
    size : 0
    padding : 0

  showMaze = ->
    obj.board.remove()
    obj.board = new Group()
    grp = obj.board
    grp.moveBelow obj.itr
    size = conf.size
    padding = conf.padding
    for i in [0...GameSize] by 1
      for j in [0...GameSize] by 1
        for k in [0...4]
          if Board[i][j][k] is true
            switch k
              when 0
                s = new Point \
                  padding + size*j \
                  ,padding + size*i
                e = s + [size,0]
              when 1
                s = new Point \
                  padding + size*j + size \
                  ,padding + size*i
                e = s + [0,size]
              when 2
                s = new Point \
                  padding + size*j + size \
                  ,padding + size*i + size
                e = s + [-size,0]
              when 3
                s = new Point \
                  padding + size*j \
                  ,padding + size*i
                e = s + [0,size]

            p = new Path.Line s,e
            p.strokeColor = '#3E2723'
            p.strokeWidth = 3
            p.strokeCap = 'round'
            grp.addChild p
    return

  gen = (x,y) ->
    if x < 0 or y < 0 or x >= GameSize or y >= GameSize
      return

    traveled[y][x] = true

    dir = [[0,-1],[1,0],[0,1],[-1,0]]
    od = [0,1,2,3]
    for [1..4]
      a = Math.floor Math.random()*4
      b = Math.floor Math.random()*4
      tmp = od[a]
      od[a] = od[b]
      od[b] = tmp

    for i in [0...4]
      d = od[i]
      try
        if traveled[ y+dir[d][1] ][ x+dir[d][0] ]
          continue
      catch
        continue
      Board[ y ][ x ][ d ] = false
      try
        switch d
          when 0 then Board[ y-1 ][ x ][ 2 ] = false
          when 1 then Board[ y ][ x+1 ][ 3 ] = false
          when 2 then Board[ y+1 ][ x ][ 0 ] = false
          when 3 then Board[ y ][ x-1 ][ 1 ] = false

      gen( x+dir[d][0], y+dir[d][1] )

    return

  ret.mazeGenerator = ->
    Board = ([true,true,true,true] for [0...GameSize] for [0...GameSize])
    traveled = (false for [0...GameSize] for [0...GameSize])
    gen( 0,0 )
    for i in [0...GameSize]
      Board[i][0][3]  = true
      Board[i][GameSize-1][1] = true
    showMaze()
    view.draw()
    return

  drawSetup = ->
    padding = conf.padding
    size = conf.size
    desCol = '#FFF176'
    obj.itr.remove()
    obj.itr = new Group()
    s = new Shape.Rectangle padding+1,padding+1,size-2,size-2
    s.fillColor = desCol
    obj.itr.addChild s
    s = new Shape.Rectangle \
          padding+1 + size*(GameSize-1) \
          ,padding+1 + size*(GameSize-1) \
          ,size-2,size-2
    s.fillColor = desCol
    obj.itr.addChild s
    s = new Shape.Circle new Point(padding+size/2,padding+size/2), size*0.3
    s.fillColor = '#D50000'
    s.name = 'ball'
    curr =
      x : 0
      y : 0
    obj.itr.addChild s
    return

  moveBall = ->
    return

  view.onKeyDown = (e) ->
    if Key.isDown 'up'
      moveBall 1
    else if Key.isDown 'right'
      moveBall 2
    else if Key.isDown 'down'
      moveBall 3
    else if Key.isDown 'left'
      moveBall 4
    return

  view.onFrame = (e) ->
    if gameStatus isnt 'play'
      return
    if gameStatus is 'pause'
      ret.mazeGenerator()
      return
    refreshTime += e.delta
    if refreshTime > 7
      refreshTime -= 7
      ret.mazeGenerator()
    startTime += e.delta
    $('.timer span').text startTime.toFixed(2)
    return

  ret.start = ->
    gameStatus = 'play'
    conf.size = 590 / GameSize
    conf.padding = 5
    drawSetup()
    startTime = 0
    ret.mazeGenerator()
    return

  ret.pause = ->
    if unableToPause isnt true
      return
    gameStatus = 'pause'
    ret.mazeGenerator()
    return

  ret.resume = ->
    gameStatus = 'play'
    ret.mazeGenerator()
    return

  ret.init = (level = 10) ->
    GameSize = level
    view.viewSize = new Size( 600,600 )
    ret.mazeGenerator()
    ret.start()
    return

  ret

game.init(22)
