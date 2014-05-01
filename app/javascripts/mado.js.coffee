$ ->
  ws = new WebSocket('ws://' + window.location.host + window.location.pathname)

  ws.onmessage = (evt) ->
    $('#markdown').html(evt.data)

  ws.onclose = ->
    console.log('Connection closed.')

  ws.onopen = ->
    console.log('Connection established!')
