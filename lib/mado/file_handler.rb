require "eventmachine"

module Mado
  class FileHandler < EventMachine::FileWatch
    def initialize(sockets)
      @sockets = sockets
    end

    def file_modified
      @sockets.each { |socket| socket.send("modified: #{path}") }
    end

    def file_moved
      @sockets.each { |socket| socket.send("moved: #{path}") }
    end

    def file_deleted
      @sockets.each { |socket| socket.send("deleted: #{path}") }
    end
  end
end
