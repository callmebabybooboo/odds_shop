class Category < ApplicationRecord
    has_many :product, dependent: :nullify
    validates :name, presence: true, uniqueness: true
end
