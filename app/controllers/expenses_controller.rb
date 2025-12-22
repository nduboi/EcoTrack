class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]
  before_action :set_categories, only: %i[ new edit create update ]

  # GET /expenses or /expenses.json
  def index
    # 1. On définit la base de recherche (Scope)
    # Si un compte est actif (Mode Focus), on ne prend que ses dépenses
    if @active_account
      @context_title = @active_account.name
      scope = current_user.expenses.where(account_id: @active_account.id)
    else
      # Sinon on prend tout
      @context_title = "Toutes les dépenses"
      scope = current_user.expenses
    end

    # 2. On applique le filtre par catégorie si demandé (Ton code existant conservé)
    if params[:category_id].present?
      scope = scope.where(category_id: params[:category_id])
    end

    # 3. Récupération finale avec tri par date
    @expenses = scope.includes(:category).order(date: :desc)

    # Pour le menu déroulant des filtres
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
    # Pré-remplissage intelligent du compte
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
        # MODIFICATION : Retour vers le compte ou la liste, pas vers le détail
        format.html { redirect_to @expense.account || expenses_path, notice: "Dépense enregistrée avec succès." }
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
        # MODIFICATION : Retour vers le compte ou la liste
        format.html { redirect_to @expense.account || expenses_path, notice: "Dépense mise à jour." }
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
      format.html { redirect_to expenses_path, notice: "Dépense supprimée.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
      # Note: j'ai remis params[:id] standard, si tu utilises Rails 8 'params.expect(:id)' fonctionne aussi
    end

    def set_categories
      # CORRECTION DE SÉCURITÉ : Uniquement les catégories de l'utilisateur
      @categories = current_user.categories.order(:nom)
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:nom, :montant, :date, :category_id, :account_id)
    end
end
