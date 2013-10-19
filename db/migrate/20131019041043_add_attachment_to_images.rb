class AddAttachmentToImages< ActiveRecord::Migration
  def change
    add_attachment :images, :path
  end
end
