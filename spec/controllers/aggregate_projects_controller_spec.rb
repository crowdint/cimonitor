require 'spec_helper'

describe AggregateProjectsController do
  render_views

  describe "with no logged in user" do
    describe "all actions except 'show'" do
      it "should redirect to the login page" do
        get :new
        response.should redirect_to(login_path)
      end

      it "should show projects within an aggregate project" do
        ap = aggregate_projects(:internal_projects_aggregate)
        get :show, :id => ap.to_param
        ap.projects.each do |project|
          response.should have_tag("div.box[project_id='#{project.id}']") do |box|
            box.should have_tag("img", :src => "checkmark.png")
          end
        end
      end
    end
  end

  describe "with a logged in user" do
    before(:each) do
      log_in(users(:valid_edward))
    end

    it "should respond to new" do
      get :new
      response.should be_success
    end

    it "should respond to edit" do
      get :edit, :id => aggregate_projects(:internal_projects_aggregate)
      response.should be_success
    end

    it "should respond to update" do
      put :update, :id => aggregate_projects(:internal_projects_aggregate), :project => { }
      response.should redirect_to(projects_path)
    end

    it "should respond to destroy" do
      lambda {
        delete :destroy, :id => aggregate_projects(:internal_projects_aggregate)
      }.should change(AggregateProject, :count).by(-1)
      response.should redirect_to(projects_path)
    end
  end
end
