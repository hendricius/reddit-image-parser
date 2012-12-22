class AddExternalFlag < ActiveRecord::Migration
  def change
    add_column :users, :external, :boolean
  end
end
