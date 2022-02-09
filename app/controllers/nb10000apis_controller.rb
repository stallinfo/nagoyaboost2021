class Nb10000apisController < ApplicationController
  skip_before_action :verify_authenticity_token

  def mujin_all
  end

  def user_touroku
  end

  def reg_market
    loc = []
    apikey = params['apikey']
    email = params['email']
    name = params['name']
    description = params['description']
    loc[0] = params['lat']
    loc[1] = params['lon']

    user = User.find_by(email: email)
    profile = {}
    responseInfo = {}
    #user = User.find_by(marketname: marketname)

    if user != nil && user.apikey == apikey && name != nil && loc[0] != nil && loc[1] != nil
      profile['id'] = user.id
      responseInfo = {status: 200, developerMessage: "Market Registrated"}
    else
      responseInfo = {status: 504, developerMessage: "Registration Failed"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, profile: profile}
    render json: jsonString.to_json
  end

  def reg_product
    email = params['email']
    apikey = params['apikey']
    user = User.find_by(email: email)
    product = {}
    profile = {}
    if user && user.apikey == apikey
      @product = Product.create(name: params['name'],
                                description: params['description'],
                                condition: params['condition'],
                                dprice: params['price'],
                                user_id: user.id,
                                image: params['image'])
      product['name'] = @product.name
      product['description'] = @product.description
      product['status'] = @product.status
      product['price'] = @product.dprice
      if @product.image.attached?
        product["image"] = rails_blob_path(product.image, only_path: true)
      else
        product["image"] = "/noimage.jpg"
      end
      profile['id'] = @product.user_id
      responseInfo = {status: 200, developerMessage: "Product registered"}
    else
      responseInfo = {status: 505, developerMessage: "Authentification failed"}
    end
    metadata = {responseInfo: responseInfo}
    jsonString = {metadata: metadata, profile: profile}
    render json: jsonString
  end

  def salesdistance
    loc1 = []
    loc2 = []
    jsonSP = []
    salesPoints = SalesPoint.all
    flag = 0
    loc1[0] = params["lat"]
    loc1[1] = params["lon"]
    range = params["range"].to_f * 0.00062137119
    current_location = Geokit::LatLng.new(loc1[0],loc1[1])
    salesPoints.each do |salesPoint|
      loc2[0] = salesPoint.lat
      loc2[1] = salesPoint.lon
      destination = "#{loc2[0]},#{loc2[1]}"
      sp = {}

      email = params['email']
      user = User.find_by(email: email)

      if current_location.distance_to(destination) <= range && user != nil && user.apikey == params["apikey"] #1.864114 # 3000 meters = 1.864114 miles
        sp["id"] = salesPoint.id
        sp["name"] = salesPoint.name
        sp["lat"] = salesPoint.lat.to_f
        sp["lon"] = salesPoint.lon.to_f
        sp["status"] = salesPoint.status
        sp["user_id"] = salesPoint.user_id
        sp["products"] = []
        sp["user"] = user.username
        sp["email"] = user.email
        sp["apikey"] = user.apikey

        products = Product.where("user_id = ?", salesPoint.user_id)
        products.each do |product|
          existProduct = SalesProductRelation.where("product_id = ? AND sales_point_id = ? AND stock > 0", product.id, salesPoint.id).first
          if existProduct
            cp = {}
            cp["id"] = product.id
            cp["stock"] = existProduct.stock
            cp["price"] = existProduct.price.to_f
            cp["name"] = product.name
            cp["content"] = product.description
            cp["created_at"] = product.created_at
            if product.image.attached?
              cp["image"] = rails_blob_path(product.image, only_path: true)
            else
              cp["image"] = "/noimage.jpg"
            end
            sp["products"].push(cp)
          end
        end
        jsonSP.push(sp)
        flag = 1
      end

    end
    if flag == 1
      responseInfo = {status: 200, developerMessage: "Sales point within #{range} miles"}
      metadata = {responseInfo: responseInfo}
      jsonString = {metadata: metadata, salespoints: jsonSP}
      render json: jsonString.to_json
    elsif flag != 1
      responseInfo = {status: 200, developerMessage: "Different Apikey or Email"}
      metadata = {responseInfo: responseInfo}
      jsonString = {metadata: metadata}
      render json: jsonString.to_json
    end
  end

end
