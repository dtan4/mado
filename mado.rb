#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'server.rb'

USAGE = <<-EOS
Usage: mado <options> <Markdown file>

Option:
    -p <port>        specify port number of HTTP Server
                     default number is 3000
    -q               quiet mode
    --no-header      not append header text to html
    --no-highlight   disable syntax highlight
    --only-wm        start only WebSocket server
    --help           show this usage
EOS

portno = 3000
quiet = false
with_header = true
highlight = true
exec_sinatra = true

if ARGV.length < 1
  STDERR.puts USAGE
  exit 1
end

while ARGV.length > 1
  arg = ARGV.shift

  case arg
  when '-p'
    portno = ARGV.shift.to_i
  when '-q'
    quiet = true
  when '--no-highlight'
    highlight = false
  when '--no-header'
    with_header = false
  when '--only-ws'
    exec_sinatra = false
  else
    STDERR.puts "invalid option: #{arg}"
  end
end

if ARGV[0] == '-h' or ARGV[0] == '--help'
  puts USAGE
  exit 0
end

filepath = ARGV.shift
mado = MadoServer.new
mado.start(filepath, portno, exec_sinatra, quiet, with_header, highlight)
