class Image < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :path
  validates_presence_of :project
  def url
    File.join(project.dir, path)
  end
  def thumb_url
    File.join(project.thumbs_dir, path)
  end
  def external_path
    path =~ /.*(\/\d*\/[^\/]*)$/
    "/images/uploads#{$1}"
  end
  def external_thumb_path
    path =~ /.*(\/\d*)\/([^\/]*)$/
    "/images/uploads#{$1}/thumbs/#{$2}"
  end

end
