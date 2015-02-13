require "spec_helper"
require "rack/test"

module Mado
  describe App do
    include Rack::Test::Methods

    let(:app) do
      described_class
    end

    describe "GET /" do
      before do
        app.set :markdown_path, fixture_path("test.md")
      end

      it "should show the root page" do
        get "/"
        expect(last_response).to be_ok
      end

      it "should contain markdown name as page title" do
        get "/"
        expect(last_response.body).to match(%r(<title>test\.md<\/title>))
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

    describe "GET /emoji/*" do
      let(:emoji_name) do
        "octocat.png"
      end

      context "when given emoji exists" do
        it "should return the image of given emoji" do
          get "/emoji/#{emoji_name}"
          expect(last_response).to be_ok
        end
      end

      context "when given emoji does not exist" do
        it "should return 404" do
          get "/emoji/#{emoji_name}.notfound"
          expect(last_response).to be_not_found
        end
      end
    end
  end
end
