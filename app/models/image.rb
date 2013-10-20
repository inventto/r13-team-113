class Image < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project
  def url
    File.join(project.url_path, filename)
  end
  def thumb_url
    File.join(project.url_thumb_path, filename)
  end
end
