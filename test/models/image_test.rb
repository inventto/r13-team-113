require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  fixtures :projects
  setup do
    @project = projects :one
  end
  test "shouldnt allow image without project" do
     assert ! Image.create(path: "/a/b").valid?
  end
  test "shouldnt allow create two image references to the same path" do
     assert ! Image.create(path: "/a/b", project: @project).valid?
  end
end
