class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if params[:provider]
      # raise request.env["omniauth.auth"].to_yaml

      auth = request.env["omniauth.auth"]
      user = User.find_by_omniauth(auth)

      if user.new_record?
        session[:omniauth_info] = {
          :expires_at => 1.minute.from_now,
          :name => user.name,
          :email => user.email,
          :service_name => user.service_name,
          :service_uid => user.service_uid,
          :service_uname => user.service_uname,
          :service_uemail => user.service_uemail
        }
        redirect_to signup_path
      else
        if params[:remember_me].to_i == 0
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        redirect_to root_path, :notice => "Logged in!"
      end
    else
      user = User.find_by_email(params[:user][:email])

      if user && user.authenticate(params[:user][:password])
        if session[:omniauth_info]
          user.service_name = session[:omniauth_info][:service_name]
          user.service_uid = session[:omniauth_info][:service_uid]
          user.service_uname = session[:omniauth_info][:service_uname]
          user.service_uemail = session[:omniauth_info][:service_uemail]
          user.create_an_user_service
        end

        if params[:remember_me].to_i == 0
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        redirect_to root_path, :notice => "Logged in!"
      else
        flash.now.alert = "Invalid email or password"
        render :new
      end
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path, :notice => "Logged out!"
  end

end
