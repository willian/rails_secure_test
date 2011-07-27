class UsersController < ApplicationController
  def new
    @user = User.new(session[:omniauth_info].except(:expires_at))
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:omniauth_info] = nil
      redirect_to signin_path, :notice => "Signed up!"
    else
      render :new
    end
  end
end
