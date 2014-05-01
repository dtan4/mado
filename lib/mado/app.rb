require "coffee-script"
require "sinatra/base"
require "slim"

module Mado
  class App < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "app"))

    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
    end

    get '/' do
      slim :index
    end

    get "/js/application.js" do
      coffee :application
    end
  end
end
