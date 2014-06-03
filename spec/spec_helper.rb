$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mado'

def fixture_path(name)
  File.expand_path(File.join("..", "fixtures", name), __FILE__)
end
