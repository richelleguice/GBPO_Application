class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update]
    before_action :check_login, only: [:edit, :update]
    authorize_resource
  
    def index
      # finding all the active owners and paginating that list (will_paginate)
      @employees = User.all.paginate(page: params[:page]).per_page(15)
    end
  
    def new
      @user = User.new
    end

    def show
    end
  
    def edit
      @user.role = "admin" if current_user.role?(:admin)
    end
  
    def create
      @user = User.new(user_params)
      @user.role = "customer" unless current_user.role?(:admin)
      if @user.save
        flash[:notice] = "Successfully added #{@user.username} as a user."
        redirect_to users_url
      else
        render action: 'new'
      end
    end
  
    def update
      if @user.update_attributes(user_params)
        flash[:notice] = "Successfully updated #{@user.username}."
        redirect_to users_url
      else
        render action: 'edit'
      end
    end
  
    def destroy
    #   if @user.destroy
    #     redirect_to users_url, notice: "Successfully removed #{@user.username} from the system."
    #   ## There is no 'else' for now; we have no restrictions on user deletion (although we probably should)
    #   # else
    #   #   render action: 'show'
    #   end
    end
  
    private
      def set_user
        @user = User.find(params[:id])
      end
  
      def user_params
        params.require(:user).permit(:username, :role, :password, :password_confirmation, :active)
      end
  
end