require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
    @project.mkdir_images_dir
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { name: "other awesome project!", url: "aweurl" }
    end
    assert_no_difference('Project.count') do
      post :create, project: { name: "other awesome project!", url: "aweurl" }
    end
  end
  test "should show project" do
    get :show, id: @project
    assert_response :success
  end
  test "should see the project by the unique url" do
    get :show, unique_url: 'first_awesome_project'
    assert_response :success
    assert assigns(:project).url == 'first_awesome_project'
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { name: @project.name, url: @project.url }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
#  test "should allow upload images to project" do
#     image = fixture_file_upload('brand.png','image/png')
#     assert_difference('Image.count', 1) do
#       post :add_image, image: image, id: @project.id # error while 
#     end
#  end
end
