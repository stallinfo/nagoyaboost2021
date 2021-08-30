class SalesPointsController < ApplicationController
  before_action :set_sales_point, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  
  # GET /sales_points or /sales_points.json
  def index
    @sales_points = current_user.sales_points #SalesPoint.all
  end

  # GET /sales_points/1 or /sales_points/1.json
  def show
  end

  # GET /sales_points/new
  def new
    @sales_point = SalesPoint.new
  end

  # GET /sales_points/1/edit
  def edit
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_point
      @sales_point = SalesPoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sales_point_params
      params.require(:sales_point).permit(:name, :description, :user_id, :status, :lat, :lon, :capacity)
    end
end
