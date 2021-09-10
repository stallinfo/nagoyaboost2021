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
  

  def apiLogin
    parameters parameters parameter set_sales_point GOOGLE_API_KEY googleapikey head id
    parameters
  end
end
