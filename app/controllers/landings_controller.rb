class LandingsController < ApplicationController
  #before_action :authenticate_user!

  def Home
    @page = 1
    @sales_points = SalesPoint.all
  end

  def ShowMap
    @page = 2
    @googleapikey = ENV['GOOGLE_API_KEY']
    @sales_points = SalesPoint.all
    render 'Home'
  end

  def ShowSalesPoint
    @sales_point = SalesPoint.find(params['id'])
    @editable = false
    @googleapikey = ENV['GOOGLE_API_KEY']
    sprs = SalesProductRelation.where("sales_point_id=?",@sales_point.id)
    @product_choices = {}
    current_user.products.each do |product|
      exist = false
      sprs.each do |spr|
        if product.id == spr.product_id
          exist = true
        end
      end
      if exist == false 
        @product_choices[product.name] = product.id
      end
    end
    render 'sales_points/show'
  end

end
