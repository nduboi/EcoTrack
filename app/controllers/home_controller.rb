class HomeController < ApplicationController
  def index
    @totalexpenses = current_user.expenses.sum(:montant)
    @totalreceipe = current_user.revenues.sum(:amount)
    @totalaccount = @totalreceipe - @totalexpenses
  end
end
