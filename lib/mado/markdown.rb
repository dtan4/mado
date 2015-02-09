require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

module Mado
  class Markdown
    class HTML < Redcarpet::Render::HTML
      include Rouge::Plugins::Redcarpet
    end

    class << self
      def convert_markdown(path)
        renderer_options = {
          filter_html: true,
          with_toc_data: true
        }
        convert_options = {
          autolink: true,
          fenced_code_blocks: true,
          lax_spacing: true,
          no_intra_emphasis: true,
          strikethrough: true,
          superscript: true,
          tables: true
        }

        renderer = HTML.new(renderer_options)
        Redcarpet::Markdown.new(renderer, convert_options).render(open(path).read)
      end
    end
  end
end
