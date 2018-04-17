class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  before_action :require_login

  include SessionsHelper

  private
  def require_login
    unless signed_in?
      flash[:danger] = "Вы должны войти"
      redirect_to sessions_login_path
    end
  end
end
