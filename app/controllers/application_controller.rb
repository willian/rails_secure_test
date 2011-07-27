class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :export_i18n_messages
  before_filter :expire_omniauth_session

  rescue_from "ActiveRecord::RecordNotFound" do |e|
    render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
  end


  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end


  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def export_i18n_messages
    SimplesIdeias::I18n.export! if Rails.env.development?
  end

  def expire_omniauth_session
    session[:omniauth_info] = nil if session[:omniauth_info] && session[:omniauth_info][:expires_at] < Time.zone.now
  end

end
