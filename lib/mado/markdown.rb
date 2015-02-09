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
        emoji_context = {
          asset_root: "emoji"
        }

        renderer = HTML.new(renderer_options)
        html = Redcarpet::Markdown.new(renderer, convert_options).render(open(path).read)
        ::HTML::Pipeline::EmojiFilter.new(html, emoji_context).call.to_s
      end

      def emoji_path(file_path)
        File.expand_path(file_path, Emoji.images_path)
      end
    end
  end
end
