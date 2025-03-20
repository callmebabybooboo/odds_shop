class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock
      t.string :image_url
      t.string :category
      t.text :option
      t.string :status

      t.timestamps
    end
  end
end
