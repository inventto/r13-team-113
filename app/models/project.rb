class Project < ActiveRecord::Base
  validates_presence_of :name, :url
  validates_uniqueness_of :url
  validates_format_of :url, with: /^[a-z0-9\-_!]*$/m, multiline: true
  after_create :mkdir_images_directory
  def directory
    @directory ||= Rails.root.join "public","images", self.id.to_s
  end
  protected
  def mkdir_images_directory
    Dir.mkdir directory if not Dir.exists? directory
  end
end
