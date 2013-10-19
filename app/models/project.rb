class Project < ActiveRecord::Base
  validates_presence_of :name, :url
  validates_uniqueness_of :url
  validates_format_of :url, with: /^[a-z0-9\-_!]*$/m, multiline: true
  has_many :images
  after_create :mkdir_images_dir
  def mkdir_images_dir
    [dir, thumbs_dir].each do |_dir|
      Dir.mkdir _dir if not Dir.exists? _dir
    end
  end
  def dir
    @dir ||= File.join UPLOADS_DIR, self.id.to_s
  end
  def thumbs_dir
    File.join(dir,"thumbs")
  end
  def image_base
    images.first
  end
end
