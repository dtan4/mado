require "eventmachine"

module Mado
  class Server
    def self.run(options)
      EM.run do
        host = options[:host] || "0.0.0.0"
        port = options[:port] || "8080"
        markdown = options[:markdown]

        app = Rack::Builder.app do
          map "/assets" do
            run Mado::App.sprockets
          end

          map "/" do
            run Mado::App
          end
        end

        Rack::Server.start(app: app, Host: host, Port: port)
      end
    end
  end
end
