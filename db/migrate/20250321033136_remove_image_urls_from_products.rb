class RemoveImageUrlsFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :image_urls, :jsonb
  end
end
