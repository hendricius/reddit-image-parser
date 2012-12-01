class ExternalLink < ActiveRecord::Migration
  def change
    add_column :images, :external_link, :string
  end
end
