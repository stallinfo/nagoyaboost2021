class SalesPoint < ApplicationRecord
  belongs_to :user
  has_many :sales_product_relations, dependent: :destroy
end
