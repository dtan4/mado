$(function(){
    ws = new WebSocket("ws://localhost:8080");

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
