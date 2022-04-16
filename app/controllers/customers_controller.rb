class CustomersController < ApplicationController
    # A callback to set up an @owner object to work with 
    before_action :set_customer, only: [:show, :edit, :update, :destroy]
    before_action :check_login, except: [:new, :create]
    authorize_resource
  
    def index
      # finding all the active owners and paginating that list (will_paginate)
      @active_customers = Customer.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_customers = Customer.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end
  
    def show
      @addresses = @customer.addresses.by_recipient.active
      @previous_orders = @customer.orders.chronological
    end
  
    def new
      @customer = Customer.new
    end
  
    def edit
        #make sure can edit, phone number or username, or greeting, or role
    end
  
    def create
      @customer = Customer.new(customer_params)
      @user = User.new(user_params)
      @user.role = "customer"
      if !@user.save
        @customer.valid?
        render action: 'new'
      else
        @customer.user_id = @user.id
        if @customer.save
          session[:user_id] = @user.id
          flash[:notice] = "#{@customer.proper_name} was added to the system."
          redirect_to customer_path(@customer) 
        else
          render action: 'new'
        end      
      end
    end
  
    def update
      respond_to do |format|
        if @customer.update_attributes(customer_params)
          format.html { redirect_to(@customer, :notice => "Successfully updated #{@customer.proper_name}.") }
          format.json { respond_with_bip(@customer) }
        else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@customer) }
        end
      end
    end
  
    # def destroy
    #   ## We don't allow destroy (will deactivate instead)
    #   if @customer.destroy
    #     # irrelevant now...
    #     # redirect_to owners_url, notice: "Successfully removed #{@owner.proper_name} from the PATS system."
    #   else
    #     # we still want this path with the base error message shown
    #     # @current_pets = @customer.pets.alphabetical.active.to_a
    #     render action: 'show'
    #   end
    # end
  
    private
      def set_customer
        @customer= Customer.find(params[:id])
      end
  
      def customer_params
        params.require(:customer).permit(:first_name, :last_name, :phone, :email, :active, :username, :password, :password_confirmation, :role, :greeting, :active)
      end
  
      def user_params      
        params.require(:customer).permit(:username, :password, :password_confirmation, :role, :greeting, :active)
      end
  
end