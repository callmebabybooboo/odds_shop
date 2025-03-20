json.extract! product, :id, :name, :description, :price, :stock, :image_url, :category, :option, :status, :created_at, :updated_at
json.url product_url(product, format: :json)
