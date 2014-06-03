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

    describe "GET /sample.png" do
      before do
        Dir.chdir(example_dir)
      end

      context "with existed image" do
        it "should return the specified image" do
          get "/sample.png"
          expect(last_response).to be_ok
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
