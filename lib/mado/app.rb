require "coffee-script"
require "sass"
require "sinatra/base"
require "slim"

module Mado
  class App < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "app"))
    set :sass, cache: false

    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
    end

    helpers do
      def markdown_dir
        @markdown_dir ||= File.dirname(settings.markdown_path)
      end
    end

    get '/' do
      slim :index
    end

    get "/css/application.css" do
      sass :application
    end

    get "/js/application.js" do
      coffee :application
    end

    get "/emoji/*" do
      emoji_path = File.expand_path(params[:splat][0], Emoji.images_path)
      send_file emoji_path, disposition: "inline"
    end

    get "/*" do
      path = File.expand_path(params[:splat][0], markdown_dir)

      if File.exist?(path)
        send_file path, disposition: "inline"
      else
        not_found
      end
    end
  end
end
