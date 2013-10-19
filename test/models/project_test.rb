require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  ONE_PROJECT = -> { Project.create name: "My first project", url:  'my_project' }
  test "should have name and url" do
    assert_no_difference 'Project.count' do
      Project.create
    end
    assert_difference 'Project.count', 1, &ONE_PROJECT
  end

  test "should have unique url" do
    assert_difference 'Project.count', 1, &ONE_PROJECT
    assert_no_difference 'Project.count', &ONE_PROJECT
  end
  test "should have a consistent url" do
    project = Project.create url: '  hahahah '
    assert ! project.errors[:url].empty?
  end
  test "should create the uploads directory for images" do
    project = ONE_PROJECT.call
    assert Dir.exists?(project.dir)
  end
  test "should allow add images and set imagebase as soon as the first image was added" do
    project = ONE_PROJECT.call
    img = project.images.create path: Rails.root.join("test","fixtures", "brands.png").to_s
    assert img == project.images.first
    assert Dir.exists? project.dir
    assert Dir.exists? project.thumbs_dir
    assert File.exists? img.path
  end
end
