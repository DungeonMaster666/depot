
class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    if User.count!=0
      user = User.find_by(name: params[:name])
      if user.try(:authenticate, params[:password])
        session[:user_id] = user.id
        redirect_to admin_url
      else
        redirect_to login_url, alert: "Invalid user/password combination"
      end
    else
      User.new(name: params[:name], password: params[:password]).save
      user = User.find_by(name: params[:name])
      session[:user_id] = user.id
      redirect_to admin_url
    end

  end

  def destroy
    session[:user_id]=nil
    redirect_to store_index_url(locale: I18n.locale), notice: "Logged out"
  end
end
