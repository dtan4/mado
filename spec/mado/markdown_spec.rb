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
    end
  end
end
