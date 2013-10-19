class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :project, index: true
      t.string :path

      t.timestamps
    end
  end
end
