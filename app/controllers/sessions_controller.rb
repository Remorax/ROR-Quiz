class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(name: params[:name])
  	if user and user.authenticate(params[:password])
  		session[:user_id]=user.id
  		redirect_to controller: 'users', action: 'welcome', id: user.id
  	else
  		flash[:error] = "Invalid Username or password"
  		redirect_to "/users/login"
  	end
  end

  def destroy
  	session[:user_id] = nil
  	flash[:notice] = "Successfully logged out"
  	redirect_to "/users/login"
  end
end
