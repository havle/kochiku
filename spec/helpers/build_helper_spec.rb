require 'spec_helper'

describe BuildHelper do
  include ActionView::Helpers
  include Haml::Helpers
  let(:build) { FactoryGirl.create(:build, :project => project) }
  let(:project) { FactoryGirl.create(:project, :repository => repository) }
  let(:repository) { FactoryGirl.create(:repository, :url => "git@git.example.com:square/web.git")}

  context "with a ruby build" do
    let!(:build_part) { FactoryGirl.create(:build_part, :build_instance => build, :options => options) }
    let(:options) { {"language" => "ruby", "ruby" => "1.9.3-p194"} }
    it "returns the ruby version info" do
      build_metadata_headers(build).should include("Ruby Version")
      build_metadata_values(build, build_part).should include("1.9.3-p194")
    end
  end

  context "with a build only having one target" do
    let!(:build_part) { FactoryGirl.create(:build_part, :build_instance => build, :paths => ['a']) }
    it "returns the info" do
      build_metadata_headers(build).should == ["Target"]
      build_metadata_values(build, build_part).should include("a")
    end
  end

  context "with a build with paths" do
    let!(:build_part) { FactoryGirl.create(:build_part, :build_instance => build, :paths => ['a', 'b']) }
    it "returns the info" do
      build_metadata_headers(build).should include("Paths")
      build_metadata_values(build, build_part).should include("2 <span class=\"paths\">(<b class=\"root\">a</b>, b)</span>")
    end
  end
end
