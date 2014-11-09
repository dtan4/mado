require "spec_helper"
require "rack/test"

module Mado
  describe App do
    include Rack::Test::Methods

    let(:app) do
      described_class
    end

    describe "GET /" do
      it "should show the root page" do
        get "/"
        expect(last_response).to be_ok
      end
    end

    describe "GET /<image>" do
      let(:base_dir) do
        fixture_path("example")
      end

      let(:other_dir) do
        fixture_path("other")
      end

      before do
        Dir.chdir(base_dir)
      end

      context "with existed image" do
        context "in the same directory" do
          before do
            described_class.set :markdown_path, File.join(base_dir, "sample.md")
          end

          it "should return the specified image" do
            get "/example.png"
            expect(last_response).to be_ok
          end
        end

        context "in the different directory" do
          before do
            described_class.set :markdown_path, File.join(other_dir, "other.md")
          end

          it "should return the specified image" do
            get "/other.png"
            expect(last_response).to be_ok
          end
        end
      end

      context "with non-existed image" do
        it "should return 404" do
          get "/notfound.png"
          expect(last_response).to be_not_found
        end
      end
    end
  end
end