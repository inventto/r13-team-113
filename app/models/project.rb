class Project < ActiveRecord::Base
  validates_presence_of :name, :url
  validates_uniqueness_of :url
  validates_format_of :url, with: /^[a-z0-9\-_!]*$/m, multiline: true
  has_many :images
  after_create :mkdir_images_directory
  UPLOADS_DIR =  if Rails.env.production?
                   "/var/www/apps/railsrumble/current/"
                 else
                   Rails.root.join("public","images", "uploads", self.id.to_s)
                 end
  def mkdir_images_directory
    Dir.mkdir directory if not Dir.exists? directory
  end
  def directory
    @directory ||= File.join UPLOADS_DIR, self.id.to_s
  end
end
