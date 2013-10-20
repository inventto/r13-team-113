class Project < ActiveRecord::Base
  validates_presence_of :name, :url
  validates_uniqueness_of :url
  validates_format_of :url, with: /^[a-z0-9\-_!]*$/m, multiline: true
  has_many :images, after_add: :set_imagebase_first
  belongs_to :imagebase, class_name: 'Image'
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
  def set_imagebase_first record
    if images.count == 1
      self.imagebase = images.first
      self.save
    end
  end
  def video_output_path
    @video_output_path ||= File.join(dir, "#{url}.mp4")
  end
  def render_video!
    File.delete video_output_path if File.exists? video_output_path
    `ffmpeg -y -r 1 -pattern_type glob -i '#{File.join(dir, "*.png")}' -c:v libx264 -pix_fmt yuv420p #{video_output_path}` 
    video_output_path
  end
end
