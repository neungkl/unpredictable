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

  boardClean = ->
    for i in [1...GameSize*2-1] by 2
      for j in [1...GameSize*2-1] by 2
        Board[i][j] = false
    return

  showMaze = ->
    obj.board.remove()
    obj.board = new Group()
    grp = obj.board
    grp.moveBelow obj.ball
    size = 600 / ( GameSize * 2 )
    padding = size / 2
    console.log size,padding
    for i in [0...GameSize*2-1] by 1
      for j in [0...GameSize*2-1] by 1
        if Board[i][j] is true
          s = new Shape.Rectangle \
            padding + size*j, \
            padding + size*i, \
            size, \
            size
          s.fillColor = 'black'
          grp.addChild s
    return

  gen = (x,y) ->
    if x < 0 or y < 0 or x >= GameSize*2-1 or y >= GameSize*2-1
      return

    traveled[y][x] = true
    Board[y][x] = true

    dir = [[-1,0],[0,-1],[1,0],[0,1]]
    for [1..10]
      a = Math.floor Math.random()*4
      b = Math.floor Math.random()*4
      tmp = dir[a]
      dir[a] = dir[b]
      dir[b] = tmp

    for i in [0...4]
      try
        if traveled[ y+dir[i][1]*2 ][ x+dir[i][0]*2 ]
          continue
      catch
        continue
      Board[ y+dir[i][1] ][ x+dir[i][0] ] = true
      gen( x+dir[i][0]*2, y+dir[i][1]*2 )

    return

  ret.mazeGenerator = ->
    Board = (false for [0...GameSize*2-1] for [0...GameSize*2-1])
    traveled = Board.slice 0
    gen( 0,0 )
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
    view.viewSize = new Size( 600,720 )
    ret.mazeGenerator()
    return

  ret

game.init(12)
