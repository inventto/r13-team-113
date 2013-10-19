class AddBaseimageEffectToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :baseimage_effect, :string
  end
end
