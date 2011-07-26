class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :export_i18n_messages

    rescue_from "ActiveRecord::RecordNotFound" do |e|
    render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
  end


    rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end


  private

  def export_i18n_messages
    SimplesIdeias::I18n.export! if Rails.env.development?
  end

end
