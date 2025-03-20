class ChangeCategoryInProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :category, :string
    add_reference :products, :category, foreign_key: true
  end
end
