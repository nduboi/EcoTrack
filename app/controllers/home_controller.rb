class HomeController < ApplicationController
  def index
    @accounts = current_user.accounts.order(:name)
    if @active_account
      @context_title = @active_account.name
      expenses_scope = current_user.expenses.where(account_id: @active_account.id)
      revenues_scope = current_user.revenues.where(account_id: @active_account.id)
      initial_balance = @active_account.balance
    else
      @context_title = "Vue Globale"
      visible_accounts = @accounts.where(hidden: false)
      visible_ids = visible_accounts.pluck(:id)
      expenses_scope = current_user.expenses.where(account_id: visible_ids)
      revenues_scope = current_user.revenues.where(account_id: visible_ids)
      initial_balance = visible_accounts.sum(:balance)
    end
    @total_expenses = expenses_scope.sum(:montant)
    @total_revenues = revenues_scope.sum(:amount)
    @recent_transactions = expenses_scope.order(date: :desc).limit(5)
    @total_balance = (initial_balance || 0) + @total_revenues - @total_expenses
  end
end
