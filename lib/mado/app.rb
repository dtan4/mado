require "sinatra/base"
require "sinatra-websocket"
require "slim"
require "sprockets"
require "sprockets-helpers"
require "bootstrap-sass"

module Mado
  class App < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "app"))
    set :sprockets, Sprockets::Environment.new
    set :sockets, []

    configure do
      Sprockets::Helpers.configure do |config|
        config.environment = sprockets
        config.prefix = "/assets"
        config.digest = true
      end

      sprockets.append_path "#{root}/javascripts"
      sprockets.append_path "#{root}/stylesheets"
      sprockets.append_path Bootstrap.stylesheets_path
      sprockets.append_path Bootstrap.javascripts_path
      sprockets.append_path Bootstrap.fonts_path
    end

    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
    end

    helpers Sprockets::Helpers

    get '/' do
      if !request.websocket?
        slim :index
      else
        request.websocket do |ws|
          ws.onopen do
            ws.send settings.markdown_path.dup
            settings.sockets << ws
          end

          ws.onmessage do |msg|
            EM.next_tick do
              settings.sockets.each { |s| s.send(msg) }
            end
          end

          ws.onclose do
            settings.sockets.delete(ws)
          end
        end
      end
    end
  end
end
