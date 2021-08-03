class LandingsController < ApplicationController
  #before_action :authenticate_user!

  def Home
    @page = 1
  end

  def ShowMap
    @page = 2
    @googleapikey = ENV['GOOGLE_API_KEY']
    render 'Home'
  end
end
