$ ()->
  $('.pause-btn').click ()->
    if $('.pause-btn').text() is 'Pause'
      game.pause()
      $('.pause-btn').text('Resume')
    else
      game.resume()
      $('.pause-btn').text('Pause')

  return
