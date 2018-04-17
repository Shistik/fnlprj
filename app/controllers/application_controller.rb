class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale,:default_url_options
  
  def set_locale
    I18n.default_locale = params[:locale]|| I18n.default_locale
    if (params[:new_locale]!= nil)
      I18n.default_locale = params[:new_locale]
      I18n.locale = params[:new_locale]
    end
  end
  def default_url_options
    { locale: I18n.locale }
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
