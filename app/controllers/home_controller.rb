class HomeController < ApplicationController
  def index
    @accounts = current_user.accounts.order(:name)
    if @active_account
      @context_title = @active_account.name
      expenses_scope = current_user.expenses.where(account_id: @active_account.id)
      revenues_scope = current_user.revenues.where(account_id: @active_account.id)
      @total_balance = @active_account.balance
    else
      @context_title = "Vue Globale"
      visible_account_ids = @accounts.where(hidden: false).pluck(:id)
      expenses_scope = current_user.expenses.where(account_id: visible_account_ids)
      revenues_scope = current_user.revenues.where(account_id: visible_account_ids)
      @total_balance = @accounts.where(hidden: false).sum(:balance)
    end
    @total_expenses = expenses_scope.sum(:montant)
    @total_revenues = revenues_scope.sum(:amount)
    @recent_transactions = expenses_scope.order(date: :desc).limit(5)
    @total_balance ||= 0
  end
end
