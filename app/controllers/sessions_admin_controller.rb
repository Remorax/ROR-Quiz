class SessionsAdminController < ApplicationController
  def new
  end

  def create

  	admin = Admin.find_by(name: params[:name])
  	if admin and admin.authenticate(params[:password])
  		session[:admin_id]=admin.id
  		redirect_to controller: 'admins', action: 'welcome', id: admin.id
  	else
  		flash[:error] = "Invalid Username or password"
  		redirect_to "/admins/login"
  	end
  end

  def destroy
  	session[:admin_id] = nil
  	flash[:notice] = "Successfully logged out"
  	redirect_to "/admins/login"
  end
end
