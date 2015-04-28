$ ()->
  $('.pause-btn').click ()->  
    if game?
      if $('.pause-btn').text() is 'Pause'
        game.pause()
        $('.pause-btn').text('Resume')
        $('#game-canvas').animate {opacity:0.2}
      else
        game.resume()
        $('.pause-btn').text('Pause')
        $('#game-canvas').animate {opacity:1}
    return

  $('.play-btn').click ()->
    $("#intro,#leaderboard").fadeOut()
    $("#game").animate {opacity:1}
    game.start()
    return

  if `'ontouchstart' in window` or `'onmsgesturechange' in window`
    $('#game .description').text('touch on maze to control')

  return
