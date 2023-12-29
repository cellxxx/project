# frozen_string_literal: true

class SessionController < ApplicationController
  skip_before_action :require_login, only: %i[login create registrate]

  def login; end

  def registrate
    unless params[:login].nil?
      @user = User.find_by(username: params[:login])
      if @user.nil? && (params[:password] == params[:password_confirm])
        @user = User.new username: params[:login], password: params[:password]
        @user.save
        sign_in @user
        redirect_to root_path
      end
    end
  end

  def create
    @user = User.find_by(username: params[:login])

    if @user&.authenticate(params[:password])
      sign_in @user
      redirect_to root_path
    else
      flash.now[:danger] = 'Неверный логин или пароль'
      redirect_to session_login_path
    end
  end

  def update
    user_here = current_user
    redirect_to "/users/#{user_here.id}/edit"
  end

  def logout
    sign_out
    redirect_to root_path
  end
end
