class LandingsController < ApplicationController
  def Home
    @page = 1
  end

  def ShowMap
    @page = 2
    render 'Home'
  end
end
