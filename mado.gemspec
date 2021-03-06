# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mado/version'

Gem::Specification.new do |spec|
  spec.name          = "mado"
  spec.version       = Mado::VERSION
  spec.authors       = ["dtan4"]
  spec.email         = ["dtanshi45@gmail.com"]
  spec.summary       = %q{Realtime Github Flavored Markdown Preview}
  spec.description   = %q{Realtime Github Flavored Markdown Preview with WebSocket}
  spec.homepage      = "https://github.com/dtan4/mado"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "coffee-script"
  spec.add_dependency "em-websocket"
  spec.add_dependency "eventmachine"
  spec.add_dependency "gemoji"
  spec.add_dependency "html-pipeline"
  spec.add_dependency "redcarpet"
  spec.add_dependency "rouge"
  spec.add_dependency "sass"
  spec.add_dependency "sinatra"
  spec.add_dependency "slim"
  spec.add_dependency "task_list"
  spec.add_dependency "thin", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sinatra-reloader"
  spec.add_development_dependency "terminal-notifier-guard"
end
