class AddTookenAtToImages < ActiveRecord::Migration
  def change
    add_column :images, :tooken_at, :datetime
    Image.all.each do |image|
      image.tooken_at = image.created_at
      image.save
    end
  end
end
