log = (x) ->
  return

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
  cur = {}
  dest = {}
  conf =
    size : 0
    padding : 0
  tool = new Tool()

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
    for [1..16]
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
    log 555
    while true
      dest =
        x : Math.floor Math.random()*GameSize
        y : Math.floor Math.random()*GameSize
      if dest.x isnt 0 or dest.y isnt 0
        break

    ###
    dest =
      x :1
      y :0
    ###

    size = conf.size
    padding = conf.padding
    obj.itr.children['dest'].position.x = padding + size*dest.x + size/2
    obj.itr.children['dest'].position.y = padding + size*dest.y + size/2
    view.draw()
    return

  drawSetup = ->
    padding = conf.padding
    size = conf.size
    desCol = '#FFF176'
    obj.itr.remove()
    obj.itr = new Group()
    s = new Shape.Rectangle padding+2,padding+2,size-4,size-4
    s.fillColor = desCol
    obj.itr.addChild s
    s = new Shape.Rectangle \
          padding + size*(GameSize-1) \
          ,padding + size*(GameSize-1) \
          ,size-4,size-4
    s.fillColor = desCol
    s.name = 'dest'
    obj.itr.addChild s
    s = new Shape.Circle new Point(padding+size/2,padding+size/2), size*0.3
    s.fillColor = '#D50000'
    s.name = 'ball'
    cur =
      x : 0
      y : 0
    obj.itr.addChild s
    return

  moveBall = (d) ->
    dir = [[0,-1],[1,0],[0,1],[-1,0]]
    x = cur.x + dir[d][0]
    y = cur.y + dir[d][1]
    padding = conf.padding
    size = conf.size
    if x < 0 or y < 0 or x >= GameSize or y >= GameSize
      return
    if Board[ cur.y ][ cur.x ][d] is true
      return

    obj.itr.children['ball'].position.x += dir[d][0]*size
    obj.itr.children['ball'].position.y += dir[d][1]*size

    cur =
      x : x
      y : y

    if cur.x is dest.x and cur.y is dest.y
      win()
    return

  win = ->
    gameStatus = 'finish'
    $('.bottom-setup').slideUp()
    $('#game').animate {opacity:0.1}
    $("#leaderboard").show().css({opacity:0}).animate {opacity:1}
    $("#leaderboard .score > span").text( startTime.toFixed(3) )

  tool.onKeyDown = (e) ->
    if Key.isDown 'up'
      moveBall 0
    else if Key.isDown 'right'
      moveBall 1
    else if Key.isDown 'down'
      moveBall 2
    else if Key.isDown 'left'
      moveBall 3
    return

  view.onFrame = (e) ->
    if gameStatus isnt 'play'
      return
    if gameStatus is 'pause'
      ret.mazeGenerator()
      return
    refreshTime += e.delta
    maxTime = 15
    if refreshTime > maxTime
      refreshTime -= maxTime*Math.floor refreshTime/maxTime
      ret.mazeGenerator()
    startTime += e.delta
    $('.timer span').text startTime.toFixed(2)
    return

  ret.start = ->
    gameStatus = 'play'
    drawSetup()
    startTime = 0
    ret.mazeGenerator()
    $('.bottom-setup').slideDown('fast')
    return

  ret.pause = ->
    if unableToPause isnt true
      return
    gameStatus = 'pause'
    return

  ret.resume = ->
    gameStatus = 'play'
    ret.mazeGenerator()
    return

  ret.init = (level = 22) ->
    GameSize = level
    view.viewSize = new Size( 600,600 )
    conf.size = 590 / GameSize
    conf.padding = 5
    #ret.start()
    return

  ret

game.init()
game.mazeGenerator()
