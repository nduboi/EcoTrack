class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!
  allow_browser versions: :modern
  before_action :set_active_account_context

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  private

  def set_active_account_context
    return unless current_user
    if session[:active_account_id].present?
      @active_account = current_user.accounts.find_by(id: session[:active_account_id])
      session[:active_account_id] = nil unless @active_account
    end
  end
end
