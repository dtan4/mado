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
        pipeline_context = {
          asset_root: ""
        }
        pipeline = ::HTML::Pipeline.new [
          ::HTML::Pipeline::EmojiFilter,
          TaskList::Filter
        ]

        renderer = HTML.new(renderer_options)
        html = Redcarpet::Markdown.new(renderer, convert_options).render(open(path).read)
        pipeline.call(html, pipeline_context)[:output].to_s
      end

      def emoji_path(file_path)
        File.join(Emoji.images_path, "emoji", file_path)
      end
    end
  end
end
