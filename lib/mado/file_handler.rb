require "eventmachine"

module Mado
  class FileHandler < EventMachine::FileWatch
    def initialize(sockets)
      @sockets = sockets
    end

    def file_modified
      @sockets.each { |socket| socket.send(convert_markdown) } if File.exist?(path)
    end

    def file_moved
      # @sockets.each { |socket| socket.send(convert_markdown) }
    end

    def file_deleted
      @sockets.each { |socket| socket.send(convert_markdown) } if File.exist?(path)
    end

    private

    def convert_markdown
      Mado::Markdown.convert_markdown(path)
    end
  end
end
