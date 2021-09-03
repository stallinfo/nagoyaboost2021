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
end
