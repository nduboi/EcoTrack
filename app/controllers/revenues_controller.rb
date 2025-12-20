class RevenuesController < ApplicationController
  before_action :set_revenue, only: %i[ show edit update destroy ]

  # GET /revenues or /revenues.json
  def index
    @revenues = current_user.revenues.all
    @total_revenue = @revenues.sum(:amount)
  end

  # GET /revenues/1 or /revenues/1.json
  def show
  end

  # GET /revenues/new
  def new
    @revenue = Revenue.new
  end

  # GET /revenues/1/edit
  def edit
  end

  # POST /revenues or /revenues.json
  def create
    @revenue = current_user.revenues.build(revenue_params)

    respond_to do |format|
      if @revenue.save
        format.html { redirect_to @revenue, notice: "Revenue was successfully created." }
        format.json { render :show, status: :created, location: @revenue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /revenues/1 or /revenues/1.json
  def update
    respond_to do |format|
      if @revenue.update(revenue_params)
        format.html { redirect_to @revenue, notice: "Revenue was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @revenue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /revenues/1 or /revenues/1.json
  def destroy
    @revenue.destroy!

    respond_to do |format|
      format.html { redirect_to revenues_path, notice: "Revenue was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_revenue
      @revenue = Revenue.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def revenue_params
      params.expect(revenue: [ :name, :description, :amount, :date, :user_id, :category_id ])
    end
end
