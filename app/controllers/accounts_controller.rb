class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[ show edit update destroy ]

  def index
    @accounts = current_user.accounts
  end

  def show
  end

  def new
    @account = current_user.accounts.build
  end

  def edit
  end

  def create
    @account = current_user.accounts.build(account_params)

    if @account.save
      redirect_to accounts_path, notice: "Le compte a été créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_path, notice: "Le compte a été mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: "Le compte a été supprimé."
  end

  def switch_context
    if params[:account_id].present?
      # On verrouille sur un compte spécifique
      session[:active_account_id] = params[:account_id]
      flash[:notice] = "Mode focus activé sur ce compte."
    else
      # On repasse en vue globale
      session[:active_account_id] = nil
      flash[:notice] = "Retour à la vue globale."
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :account_type, :bank_name, :iban, :bic, :balance)
  end
end
