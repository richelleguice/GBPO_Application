class AddressesController < ApplicationController
    # A callback to set up an @owner object to work with 
    before_action :set_address, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    def index
      # finding all the active addresses and paginating that list (will_paginate)
      @active_addresses = Address.active.paginate(page: params[:page]).per_page(10)
      @inactive_addresses = Address.inactive.paginate(page: params[:page]).per_page(15)
    end
  
    def show
      # authorize! :show, @owner
      # get all the pets for this owner
      @current_addresses = @address.active.to_s
    end
  
    def new
      @address = Address.new
    end
  
    def edit
    end
  
    def create
      @address = Address.new(address_params)
      if @address.save
        flash[:notice] = "The address was added to #{@address.customer.proper_name}."
        redirect_to customer_path(@address.customer)
      else
        # @address.user_id = @user.id
        render action: 'new' 
      end
    end
  
    def update
      #respond_to do |format|
        if @address.update_attributes(address_params)
          redirect_to addresses_path, notice: "The address was edited."
        else
          render action: 'edit'
        end
      #end
    end
  
    private
      def set_address
        @address = Address.find(params[:id])
      end
  
      def address_params
        params.require(:address).permit(:customer_id, :is_billing, :recipient, :street_1, :city, :state, :zip, :active, :username)
      end
  
end