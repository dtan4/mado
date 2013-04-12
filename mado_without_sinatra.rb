#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'em-websocket'
require 'redcarpet'

# TODO: daemonize

class Mado
  PORTNO = 8080

  def initialize
    @connections = []
  end

  # start WebSocket server
  def start(filepath)
    # TODO: --with-header option
    @header_html =
      "<div align=\"center\">mado: <strong>#{File.absolute_path(filepath)}</strong><hr></div>\n"

    Thread.new do
      system("open index.html")
      observe_file(filepath)
    end

    EventMachine.run do
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => PORTNO) do |ws|
        ws.onopen {
          puts "#{Time.now} - mado: Connection established!"
          @connections << ws unless @connections.include?(ws)
          send_markdown_html(filepath)
        }

        ws.onclose {
          puts "#{Time.now} - mado: Connection closed."
          @connections.delete_if { |con| con == ws }
        }
      end

      # TODO: error handling

      puts "#{Time.now} - mado: Server started!"
      puts "                    Now observing: #{filepath}"
    end
  end

  # observe file saving, notify if modified
  def observe_file(filepath)
    loop { break if File.exist?(filepath) }

    # set prev_mtime to ZERO
    prev_mtime = File.mtime(filepath) - File.mtime(filepath)

    loop do
      mtime = File.mtime(filepath)

      if mtime != prev_mtime and @connections.length > 0
        puts "#{Time.now} - mado: Refresh view."
        send_markdown_html(filepath)
        prev_mtime = mtime
      end

      sleep 1
    end
  end

  # send generated html to each client
  def send_markdown_html(filepath)
    html = generate_html(filepath)

    @connections.each { |con| con.send html } unless html.nil?
  end

  def generate_html(filepath)
    return @header_html unless File.exist?(filepath)

    markdown = File.open(filepath).read
    html =
      @header_html + Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(markdown)
  end
end

if ARGV.length < 1
  STDERR.puts "usage: mado path_to_markdown"
  exit 1
end

filepath = ARGV[0]

mado = Mado.new
mado.start(filepath)
