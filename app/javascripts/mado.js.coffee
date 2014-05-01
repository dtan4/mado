$ ->
  ws = new WebSocket("ws://#{window.location.hostname}:8081#{window.location.pathname}")

  ws.onmessage = (evt) ->
    $('#markdown').html(evt.data)

  ws.onclose = ->
    console.log('Connection closed.')

  ws.onopen = ->
    console.log('Connection established!')
