class LandingsController < ApplicationController
  def Home
    @page = 1
  end

  def ShowMap
    @page = 2
    @googleapikey = ENV['GOOGLE_API_KEY']
    render 'Home'
  end
end
