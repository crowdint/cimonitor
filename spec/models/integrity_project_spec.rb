require File.dirname(__FILE__) + '/../spec_helper'

describe IntegrityProject do
  before(:each) do
    @project = IntegrityProject.new(:name => "my_integrity_project", :feed_url => "http://foo.bar.com:9292/example_project")
  end
  
  describe "#project_name" do
    it "should return nil when feed_url is nil" do
      @project.feed_url = nil
      @project.project_name.should be_nil
    end

    it "should extract the project name from url" do
      @project.project_name.should == "example_project"
    end

    it "should extract the project name from Atom url regardless of capitalization" do
      @project.feed_url = @project.feed_url.upcase
      @project.project_name.should == "EXAMPLE_PROJECT"
    end
  end

  describe 'validations' do
    it "should require a Integrity url format" do
      @project.should have(0).errors_on(:feed_url)
      @project.feed_url = 'http://foo.bar.com:9292/wrong/wrong'
      @project.should have(1).errors_on(:feed_url)
    end
  end

  describe "status parsers" do
    it "should handle bad data" do
      @project.status_parser('asdfa').should_not be_nil
      @project.building_parser('asdfas').should_not be_nil
    end
    
    it "should be for Integrity" do
      @project.status_parser('whatever').should be_a(IntegrityStatusParser)
      @project.building_parser('whatever').should be_a(IntegrityStatusParser)
    end
  end

  describe "#build_status_url" do
    it "should use the same url as feed url" do
      @project.build_status_url.should == @project.feed_url
    end
  end
end