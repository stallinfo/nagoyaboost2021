class ApisController < ApplicationController
  def salespoints
    salespoints = SalesPoint.all
    jsonsalespoints = []
    counter = 0
    salespoints.each do |salespoint|
      jsonsalespoints[counter] = {}
      jsonsalespoints[counter]["id"] = salespoint.id
      jsonsalespoints[counter]["name"] = salespoint.name
      subcounter = 0
      jsonsalespoints[counter]["products"] = []
      salespoint.sales_product_relations.each do |spr|
        product = Product.find(spr.product_id)
        jsonsalespoints[counter]["products"][subcounter] = {}
        jsonsalespoints[counter]["products"][subcounter]["id"] = product.id
        if product.image.attached?
          jsonsalespoints[counter]["products"][subcounter]["image"] = rails_blob_path(product.image, only_path: true)
        else
          jsonsalespoints[counter]["products"][subcounter]["image"] = "no image"
        end
        subcounter += 1
      end
      counter += 1
    end
    responseInfo = {status: 200, developerMessage: "All sales points"}
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, salespoints: jsonsalespoints}
    render json: jsonString.to_json
  end
  

  def performlogin
    id = params['id'].to_i
    password = params['password']
    apikey = params['apikey']
    email = params['email']
    profile = {}
    responseInfo = {}
    if password != nil && password != ""
      user = User.find_by(email: email)
      if user != nil 
      
        #generate apikey
        apikey = SecureRandom.urlsafe_base64
        user.update(apikey: apikey)
        # debugger
        profile["apikey"] = apikey
        profile["id"] = user.id
        profile["name"] = user.username
        responseInfo = {status: 201, developerMessage: "New API key generated"}
      else 
        responseInfo = {status: 502, developerMessage: "User not found" } 
      end 
    elsif apikey != nil && apikey != ""
      user = User.find_by(apikey: apikey)
      if user != nil 
        profile["apikey"] = apikey
        profile["id"] = user.id
        profile["name"] = user.username
        responseInfo = {status: 200, developerMessage: "User authorized"}
      else
        responseInfo = {status: 503, developerMessage: "Syntax Error" }
      end
    else
      responseInfo = {status: 501, developerMessage: "Error" }  
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, profile: profile}
    render json: jsonString.to_json
  end
end
