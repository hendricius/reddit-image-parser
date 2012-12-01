class AddAuthorAndTitle < ActiveRecord::Migration
  def change
    add_column :images, :author, :string
    add_column :images, :title, :string
  end
end
