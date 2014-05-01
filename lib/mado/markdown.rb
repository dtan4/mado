require "github/markup"

module Mado
  class Markdown
    def self.convert_markdown(path)
      GitHub::Markup.render(File.join(Dir.pwd, path))
    end
  end
end
