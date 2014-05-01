require "eventmachine"
require "em-websocket"

module Mado
  class Server
    def self.run(options)
      EM.kqueue = true if EM.kqueue?

      EM.run do
        sockets = []

        host = options[:host] || "0.0.0.0"
        port = options[:port] || "8080"
        debug = options[:debug] || false
        markdown = options[:markdown]

        EM.watch_file(markdown, Mado::FileHandler, sockets)

        EM::WebSocket.start(host: host, port: 8081, debug: debug) do |ws|
          ws.onopen do
            sockets << ws unless sockets.include?(ws)
          end

          ws.onclose do
            sockets.delete(ws)
          end
        end

        app = Rack::Builder.app do
          map "/assets" do
            run Mado::App.sprockets
          end

          map "/" do
            run Mado::App
          end
        end

        Rack::Server.start(app: app, Host: host, Port: port)

        trap("TERM") { EM.stop }
        trap("INT") { EM.stop }
      end
    end
  end
end
