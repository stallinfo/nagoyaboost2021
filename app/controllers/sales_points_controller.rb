class SalesPointsController < ApplicationController
  before_action :set_sales_point, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /sales_points or /sales_points.json
  def index
    @sales_points = current_user.sales_points #SalesPoint.all
  end

  # GET /sales_points/1 or /sales_points/1.json
  def show
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
  end

  # GET /sales_points/new
  def new
    @sales_point = SalesPoint.new
    @sales_product_relation = SalesProductRelation.new
    @googleapikey = ENV['GOOGLE_API_KEY']
  end

  # GET /sales_points/1/edit
  def edit
    @googleapikey = ENV['GOOGLE_API_KEY']
  end

  # POST /sales_points or /sales_points.json
  def create
    @sales_point = SalesPoint.new(sales_point_params)

    respond_to do |format|
      if @sales_point.save
        format.html { redirect_to @sales_point, notice: "Sales point was successfully created." }
        format.json { render :show, status: :created, location: @sales_point }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sales_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_points/1 or /sales_points/1.json
  def update
    respond_to do |format|
      if @sales_point.update(sales_point_params)
        format.html { redirect_to @sales_point, notice: "Sales point was successfully updated." }
        format.json { render :show, status: :ok, location: @sales_point }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sales_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_points/1 or /sales_points/1.json
  def destroy
    @sales_point.destroy
    respond_to do |format|
      format.html { redirect_to sales_points_url, notice: "Sales point was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_sales_product_relation
    sales_point_id = sales_product_relation_params['sales_point_id']
    product_id = sales_product_relation_params['product_id']
    price = sales_product_relation_params['price'].to_d

    @sales_point = SalesPoint.find(sales_point_id)
    @product = Product.find(product_id)
    if price <= 0 
      price = @product.dprice
    end

    SalesProductRelation.create(sales_point_id: sales_point_id, product_id: product_id, price: price)
    redirect_to @sales_point
  end

  def edit_sales_product_relation
    sales_product_relation = SalesProductRelation.find(sales_product_relation_params['id'])
    @sales_point = SalesPoint.find(sales_product_relation.sales_point_id)
    sales_product_relation.update(price: sales_product_relation_params['price'].to_d, product_id: sales_product_relation_params['product_id'].to_i)
    redirect_to @sales_point
  end
  
  def delete_sales_product_relation
    sales_product_relation = SalesProductRelation.find(params[:id])
    @sales_point = SalesPoint.find(sales_product_relation.sales_point_id)
    sales_product_relation.destroy
    redirect_to @sales_point
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_point
      @sales_point = SalesPoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sales_point_params
      params.require(:sales_point).permit(:name, :description, :user_id, :status, :lat, :lon, :capacity)
    end

    def sales_product_relation_params
      params.require(:sales_product_relation).permit(:price, :product_id, :sales_point_id, :id)
    end

end
