# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionHelper

  before_action :require_login
  around_action :switch_locale

  private

  def require_login
    unless signed_in?
      flash[:danger] = 'Требуется логин'
      redirect_to session_login_url
    end
  end

  def switch_locale(&action)
    locale = locale_from_url || I18n.default_locale
    I18n.with_locale locale, &action
  end

  def locale_from_url
    locale = params[:locale]
    return locale if I18n.available_locales.map(&:to_s).include?(locale)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
