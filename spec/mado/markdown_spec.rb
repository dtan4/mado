require "spec_helper"

module Mado
  describe Markdown do
    let(:markdown_path) do
      fixture_path("test.md")
    end

    describe ".convert_markdown" do
      subject { described_class.convert_markdown(markdown_path) }

      it { is_expected.to match(%r(<h1 id="header">header</h1>)) }
      it { is_expected.to match(%r(<li>item</li>)) }
      it { is_expected.to match(%r(<pre class="highlight ruby"><code>)) }
      it { is_expected.to match(%r(<img class="emoji" .+?src="/emoji/.+?">)) }
      it { is_expected.to match(%r(<input [^<>]*type="checkbox"[^<>]*>)) }
    end

    describe ".emoji_path" do
      let(:file_path) do
        "octocat.png"
      end

      it "should return emoji path" do
        expect(described_class.emoji_path(file_path)).to match(/octocat\.png/)
      end

      it "should return existed path" do
        expect(File.exist?(described_class.emoji_path(file_path))).to be true
      end
    end
  end
end
