class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]
  before_action :set_categories, only: %i[ new edit create update ]

  # GET /expenses or /expenses.json
  def index
    if params[:category_id].present?
      @expenses = current_user.expenses.where(category_id: params[:category_id])
    else
      @expenses = current_user.expenses.includes(:category).all
    end
    @categories = current_user.categories.order(:nom)
    @total_amount = @expenses.sum(:montant)
    respond_to do |format|
      format.html
      format.json { render json: @expenses.as_json(
        include: { category: { only: :nom } },
        except: :category_id
      )}
    end
  end

  # GET /expenses/1 or /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @expense.account_id = params[:account_id] || @active_account&.id
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses or /expenses.json
  def create
    @expense = current_user.expenses.build(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: "Expense was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy!

    respond_to do |format|
      format.html { redirect_to expenses_path, notice: "Expense was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def set_categories
    @categories = Category.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:nom, :montant, :date, :category_id, :account_id)
    end
end
