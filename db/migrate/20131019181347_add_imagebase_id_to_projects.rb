class AddImagebaseIdToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :imagebase, index: true
  end
end
