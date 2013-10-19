class Image < ActiveRecord::Base
  belongs_to :project
  has_attached_file :path, styles: {thumbnail: "64x64#", medium: '256x256#', large: '500x500#'}
  before_save :decode_base64_image
  attr_accessor :content_type, :original_filename, :image_data

  protected
  def decode_base64_image
    if image_data && content_type && original_filename
      decoded_data = Base64.decode64(image_data)
      data = StringIO.new(decoded_data)
      data.class_eval do
        attr_accessor :content_type, :original_filename
      end

      data.content_type = content_type
      data.original_filename = File.basename(original_filename)

      self.path = data
    end
  end
end
