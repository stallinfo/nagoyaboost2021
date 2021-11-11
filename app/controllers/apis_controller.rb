class ApisController < ApplicationController
  skip_before_action :verify_authenticity_token
  def salespoints
    salespoints = SalesPoint.all
    jsonsalespoints = []
    counter = 0
    salespoints.each do |salespoint|
      jsonsalespoints[counter] = {}
      jsonsalespoints[counter]["id"] = salespoint.id
      jsonsalespoints[counter]["name"] = salespoint.name
      jsonsalespoints[counter]["lat"] = salespoint.lat.to_f
      jsonsalespoints[counter]["lon"] = salespoint.lon.to_f
      jsonsalespoints[counter]["status"] = salespoint.status
      jsonsalespoints[counter]["user_id"] = salespoint.user_id
      subcounter = 0
      jsonsalespoints[counter]["products"] = []
      salespoint.sales_product_relations.each do |spr|
        product = Product.find(spr.product_id)
        jsonsalespoints[counter]["products"][subcounter] = {}
        jsonsalespoints[counter]["products"][subcounter]["id"] = product.id
        jsonsalespoints[counter]["products"][subcounter]["name"] = product.name
        jsonsalespoints[counter]["products"][subcounter]["description"] = product.description
        jsonsalespoints[counter]["products"][subcounter]["status"] = product.status
        jsonsalespoints[counter]["products"][subcounter]["price"] = spr.price.to_f
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
    password = params['password']
    email = params['email']
    profile = {}
    responseInfo = {}
    if password != nil && password != "" 
      user = User.find_by(email: email)
      if user != nil && user.valid_password?(password)
        #generate apikey
        #temporary remark
        if !user.apikey
          apikey = SecureRandom.urlsafe_base64
          user.update(apikey: apikey)
        end
        #-- end of temporary remark
        #debugger
        profile["apikey"] = user.apikey
        profile["id"] = user.id
        profile["name"] = user.username
        responseInfo = {status: 201, developerMessage: "New API key generated"}
      else 
        responseInfo = {status: 502, developerMessage: "User not found" } 
      end
    else
      responseInfo = {status: 501, developerMessage: "Error" }  
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, profile: profile}
    render json: jsonString.to_json
  end

  def performapikeylogin
    apikey = params['apikey']
    email = params['email']
    profile = {}
    responseInfo = {}

    if apikey != nil && apikey != ""
      user = User.find_by(apikey: apikey)
      if user != nil && user.email == email
        profile["apikey"] = apikey
        profile["id"] = user.id
        profile["name"] = user.username
        responseInfo = {status: 200, developerMessage: "User authorized"}
      else
        responseInfo = {status: 503, developerMessage: "Syntax Error" }
      end
    else
      responseInfo = {status: 501, developerMessage: "Error"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, profile: profile}
    render json: jsonString.to_json
  end

  def changepassword 
    apikey = params['apikey']
    email = params['email']
    password = params['password']
    profile = {}
    responseInfo = {}
    user = User.find_by(apikey: apikey)
    if user != nil && user.email == email
      apikey = SecureRandom.urlsafe_base64
      user.update(password: password, apikey: apikey)
      profile["apikey"] = apikey
      profile["id"] = user.id
      profile["name"] = user.username
      responseInfo = {status: 200, developerMessage: "Password Changed"}
    else
      responseInfo = {status: 504, developerMessage: "Rejected"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, profile: profile}
    render json: jsonString.to_json
  end

  def submitnewprofile
    email = params['email']
    password = params['password']
    username = params['username']
    apikey = SecureRandom.urlsafe_base64
    User.create(email: email, username: username, password: password, apikey: apikey)
    profile = {}
    responseInfo = {}
    user = User.find_by(email: email)
    if user != nil && user.valid_password?(password) && apikey == user.apikey
      profile['apikey'] = apikey
      profile['id'] = user.id
      profile['name'] = username
      responseInfo = {status: 200, developerMessage: "User Created"}
    else
      responseInfo = {status: 505, developerMessage: "Registration Failed"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, profile: profile}
    render json: jsonString.to_json
  end

  def updatestock
    apikey = params['apikey']
    sales_point_id = params['sp_id'].to_i
    product_name = params['p_name']
    email = params['email']
    stock = params['stock'].to_i
    user = User.find_by(email: email)
    products = []
    product = Product.find_by(name: product_name)
    if user.apikey == apikey && product
      spr = SalesProductRelation.where("sales_point_id=? AND product_id=? ", sales_point_id, product.id).first
      sp = SalesPoint.find(sales_point_id)
      if spr 
        spr.update(stock: stock)
        responseInfo = {status: 202, developerMessage: "Product #{product.name} stock is updated to #{stock}"}
        product_relations = sp.sales_product_relations
        jsonProductRelations = []
        product_relations.each do |product_relation|
          if !product_relation.stock
            product_relation.update(stock: 0)
          elsif product_relation.stock > 0
            jsonProductRelation = {}
            product = Product.find(product_relation.product_id)
            jsonProductRelation["p_name"] = product.name
            jsonProductRelation["stock"] = product_relation.stock
            jsonProductRelation["price"] = product_relation.price
            if product.image.attached?
              jsonProductRelation["image"] = rails_blob_path(product.image, only_path: true)
            else
              jsonProductRelation["image"] = "empty"
            end
            jsonProductRelations.append(jsonProductRelation)
          end
        end
      else
        responseInfo = {status: 507, developerMessage: "Product #{product_name} not found in #{sp.name}"}
      end
    else
      responseInfo = {status: 506, developerMessage: "Product update failed"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, products: jsonProductRelations}
    render json: jsonString.to_json
  end

  def currentstockallsp
    email = params['email']
    apikey = params['apikey']
    user = User.find_by(email: email)
    jsonProductRelations = []
    jsonProductRelation = {}
    if user && user.apikey == apikey
      responseInfo = {status: 202, developerMessage: "Current all sales points"}
      sps = user.sales_points
      sps.each do |sp|
        sp.sales_product_relations.each do |spr|
          product = Product.find(spr.product_id)
          jsonProductRelation = {}
          if spr.stock && spr.stock > 0 && product
            jsonProductRelation["sp_id"] = sp.id
            jsonProductRelation["p_name"] = product.name
            jsonProductRelation["stock"] = spr.stock
            jsonProductRelation["price"] = spr.price
            jsonProductRelation["id"] = spr.id
            if product.image.attached?
              jsonProductRelation["image"] = rails_blob_path(product.image, only_path: true)
            else
              jsonProductRelation["image"] = "empty"
            end
            jsonProductRelations.append(jsonProductRelation)
          end
        end
      end
    else
      responseInfo = {status: 504, developerMessage: "Authentification failed"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, products: jsonProductRelations}
    render json: jsonString.to_json

  end

  def currentstocksp
    email = params['email']
    apikey = params['apikey']
    sp_id = params['sp_id'].to_i
    user = User.find_by(email: email)
    sp = SalesPoint.find(sp_id)
    jsonProductRelations = []
    if user && user.apikey == apikey && sp.user_id == user.id
      responseInfo = {status: 202, developerMessage: "Current #{sp.name}"}
      sp.sales_product_relations.each do |spr|
        product = Product.find(spr.product_id)
        jsonProductRelation = {}
        if spr.stock && spr.stock > 0 && product
          jsonProductRelation["sp_id"] = sp.id
          jsonProductRelation["p_name"] = product.name
          jsonProductRelation["stock"] = spr.stock
          jsonProductRelation["price"] = spr.price
          jsonProductRelation["id"] = spr.id
          if product.image.attached?
            jsonProductRelation["image"] = rails_blob_path(product.image, only_path: true)
          else
            jsonProductRelation["image"] = "empty"
          end
          jsonProductRelations.append(jsonProductRelation)
        end
      end
    else
      responseInfo = {status: 504, developerMessage: "Authentification failed"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, products: jsonProductRelations}
    render json: jsonString.to_json

  end

end
