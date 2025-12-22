class RevenuesController < ApplicationController
  before_action :set_revenue, only: %i[ show edit update destroy ]
  before_action :set_categories, only: %i[ new edit create update ]

  def index
    if @active_account
      @context_title = @active_account.name
      @revenues = current_user.revenues.where(account_id: @active_account.id)
      @total_revenue = @revenues.sum(:amount)
    else
      @revenues = current_user.revenues.all
      @total_revenue = @revenues.sum(:amount)
    end
  end

  def show
  end

  def new
    @revenue = Revenue.new
    @revenue.account_id = params[:account_id] || @active_account&.id
  end

  def edit
  end

  def create
    @revenue = current_user.revenues.build(revenue_params)

    respond_to do |format|
      if @revenue.save
        format.html { redirect_to @revenue.account || revenues_path, notice: "Revenu ajouté avec succès." }
        format.json { render :show, status: :created, location: @revenue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @revenue.update(revenue_params)
        format.html { redirect_to @revenue, notice: "Le revenu a été mis à jour.", status: :see_other }
        format.json { render :show, status: :ok, location: @revenue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @revenue.destroy!

    respond_to do |format|
      format.html { redirect_to revenues_path, notice: "Le revenu a été supprimé.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_revenue
      @revenue = Revenue.find(params[:id])
    end
    def set_categories
      @categories = current_user.categories.order(:nom)
    end

    def revenue_params
      params.require(:revenue).permit(:name, :description, :amount, :date, :user_id, :account_id)
    end
end
