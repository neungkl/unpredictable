log = (x) -> console.log x

window.game = do ->
  ret = {}
  GameSize = -1
  Board = []
  traveled = []
  obj =
    ball : new Group()
    board : new Group()
    status : new Group()
  refreshTime = 0

  showMaze = ->
    obj.board.remove()
    obj.board = new Group()
    grp = obj.board
    grp.moveBelow obj.ball
    size = 590 / GameSize
    padding = 5
    console.log size,padding
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
            p.strokeColor = 'black'
            grp.addChild p
    return

  gen = (x,y) ->
    if x < 0 or y < 0 or x >= GameSize or y >= GameSize
      return

    traveled[y][x] = true

    dir = [[0,-1],[1,0],[0,1],[-1,0]]
    od = [0,1,2,3]
    for [1..10]
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

  view.onFrame = (e) ->
    refreshTime += e.delta
    if refreshTime > 3
      refreshTime -= 3
      ret.mazeGenerator()

  ret.init = (level = 10) ->
    GameSize = level
    view.viewSize = new Size( 600,600 )
    ret.mazeGenerator()
    return

  ret

game.init(25)
