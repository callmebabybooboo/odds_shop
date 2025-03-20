class ChangeImageUrlToImageUrlsInProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :image_url, :string
    add_column :products, :image_urls, :jsonb, default: [], null: false
  end
end
