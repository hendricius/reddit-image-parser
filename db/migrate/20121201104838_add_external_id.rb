class AddExternalId < ActiveRecord::Migration
  def change
    add_column :images, :external_id, :string
  end
end
