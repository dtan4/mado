require "eventmachine"
require "github/markup"

module Mado
  class FileHandler < EventMachine::FileWatch
    def initialize(sockets)
      @sockets = sockets
    end

    def file_modified
      @sockets.each { |socket| socket.send(convert_markdown) }
    end

    def file_moved
      # @sockets.each { |socket| socket.send(convert_markdown) }
    end

    def file_deleted
      @sockets.each { |socket| socket.send(convert_markdown) }
    end

    private

    def convert_markdown
      GitHub::Markup.render(File.join(Dir.pwd, path))
    end
  end
end
