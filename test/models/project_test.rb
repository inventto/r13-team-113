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
end
