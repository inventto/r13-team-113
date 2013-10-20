class RenamePathToFilenameOnPicture < ActiveRecord::Migration
  def change
    rename_column 'images','path', 'filename'
    Image.all.each do |image|
      image.filename = image.filename.split("/").last
      image.save
    end
  end
end
