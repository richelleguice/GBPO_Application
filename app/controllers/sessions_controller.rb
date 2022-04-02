class SessionsController < ApplicationController
    include AppHelpers::Cart

    def new
    end
    
    def create
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id
        if logged_in? && (current_user.role?(:customer) || current_user.role?(:admin))
            create_cart
        end
        redirect_to home_path, notice: "Logged in!"
      else
        flash.now.alert = "Username and/or password is invalid"
        render "new"
      end
    end
    
    def destroy
      session[:user_id] = nil
      session[:cart] = nil
      redirect_to home_path, notice: "Logged out!"
    end
end