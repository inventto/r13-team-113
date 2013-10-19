class Image < ActiveRecord::Base
  belongs_to :project
  has_attached_file :path, styles: {thumbnail: "64x64#", medium: '256x256#', large: '500x500#'}
end
