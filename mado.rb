#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'em-websocket'
require 'redcarpet'
require 'haml'
require 'sinatra/base'
require 'thin'

class MadoBase < Sinatra::Base
  get '/' do
    haml :index
  end
end

class Mado
  WS_PORTNO = 8080

  def initialize
    @channel = EventMachine::Channel.new
  end

  # start server
  def start(filepath, portno, quiet, with_header)
    @header_html = with_header ?
    "<div align=\"center\">mado: <strong>#{File.absolute_path(filepath)}</strong><hr></div>\n" : ""

    Thread.new do
      observe_file(filepath, quiet)
    end

    EventMachine.run do
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => WS_PORTNO) do |ws|
        ws.onopen {
          puts "#{Time.now} - mado: Connection established!" unless quiet
          sid = @channel.subscribe{ |msg| ws.send msg }
          send_markdown_html(filepath)

          ws.onclose {
            @channel.unsubscribe(sid)
            puts "#{Time.now} - mado: Connection closed." unless quiet
          }
        }
      end

      MadoBase.run!(:port => portno)
      puts "#{Time.now} - mado: Server started!"
      puts "#{Time.now} - mado: file = #{File.absolute_path(filepath)}"
    end
  end

  private
  # observe file saving every one second, notify if modified
  def observe_file(filepath, quiet)
    unless File.exist?(filepath)
      File.open(filepath, "w").puts("")
    end

    # set prev_mtime to ZERO
    prev_mtime = File.mtime(filepath) - File.mtime(filepath)

    loop do
      mtime = File.mtime(filepath)

      if mtime != prev_mtime
        puts "#{Time.now} - mado: Refresh view." unless quiet
        send_markdown_html(filepath)
        prev_mtime = mtime
      end

      sleep 1
    end
  end

  # send generated HTML to each client
  def send_markdown_html(filepath)
    html = generate_html(filepath)

    @channel.push(html) unless html.nil?
  end

  # generate HTML from markdown
  def generate_html(filepath)
    return @header_html unless File.exist?(filepath)

    markdown = File.open(filepath).read
    html =
      @header_html + Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(markdown)
  end
end



portno = 3000
quiet = false
with_header = true

if ARGV.length < 1
  STDERR.puts "usage: mado [-p portno] [--no-header] file"
  exit 1
end

while ARGV.length > 1
  arg = ARGV.shift

  case arg
  when '-p'
    portno = ARGV.shift.to_i
  when '-q'
    quiet = true
  when '--no-header'
    with_header = false
  else
    STDERR.puts "invalid option: #{arg}"
  end
end

filepath = ARGV.shift
mado = Mado.new
mado.start(filepath, portno, quiet, with_header)
