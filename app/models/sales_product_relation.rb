class SalesProductRelation < ApplicationRecord
  belongs_to :sales_point
  belongs_to :product
end
