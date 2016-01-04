require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  fixtures :projects
  setup do
    @project = projects :one
  end
  test "shouldnt allow image without project" do
     assert ! Image.create(filename: "/a/b").valid?
  end
  test "shouldnt allow create without filename" do
     assert ! Image.create(project: @project).valid?
  end
end
