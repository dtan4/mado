require "github/markup"

module Mado
  class Markdown
    def self.convert_markdown(path)
      GitHub::Markup.render(path)
    end
  end
end
