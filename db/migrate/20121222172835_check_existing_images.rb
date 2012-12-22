class CheckExistingImages < ActiveRecord::Migration
  def change
    Image.find_each(:batch_size => 1000) do |i|
      next if i.user
      i.assign_user
      i.save
    end
  end
end
