json.extract! sales_point, :id, :name, :description, :user_id, :status, :lat, :lon, :capacity, :created_at, :updated_at
json.url sales_point_url(sales_point, format: :json)
