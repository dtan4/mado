$(function(){
    ws = new WebSocket("ws://" + window.location.host + window.location.pathname);

    ws.onmessage = function(evt){
        $("#markdown").html(evt.data)
    };

    ws.onclose = function(){
        console.log("Connection closed.")
    };

    ws.onopen = function(){
        console.log("Connection established!")
    };
});
