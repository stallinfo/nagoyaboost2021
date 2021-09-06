class Product < ApplicationRecord
  belongs_to :user
  has_many :sales_product_relations, dependent: :destroy
  has_one_attached :image
end
