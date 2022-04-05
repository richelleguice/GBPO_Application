class ItemPricesController < ApplicationController
    # A callback to set up an @owner object to work with 
    before_action :set_itemPrices
    before_action :check_login
    authorize_resource
  
    # def index
    #   # finding all the active owners and paginating that list (will_paginate)
    #   @categories = Category.all.paginate(page: params[:page]).per_page(10)
    #   @featured_items = Item.featured.to_a
    #   @other_items = Item.all.to_a - @featured_items
    # end
  
    # def show
    #   if logged_in? && (current_user.role?(:admin))
    #     @prices = @item.item_prices.to_a
    #   end
      
    #   @similar_items = Item.for_category(@item.category).active.to_a - [@item]
    # end
  
    def new
      @item = Item.new
    end
  
    def edit
    end
  
    def create
      @itemPrice = ItemPrice.new(itemPrice_params)
        # @item.user_id = @item.id
        if @itemPrice.save
          flash[:notice] = "#{@item.name} was added to the system."
          redirect_to item_path(@item) 
        else
          render action: 'new'
        end      
    end
  
    def update
      respond_to do |format|
        if @item.update_attributes(item_params)
          format.html { redirect_to(@item, :notice => "Successfully updated the price #{@itemPrice.name}.") }
          format.json { respond_with_bip(@item) }
        else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@item) }
        end
      end
    end
  
    # def destroy
    #   if @item.destroy
    #     item = nil
    #     redirect_to items_url, notice: "Destroyed!"
    #   else
    #     redirect_back fallback_location: item_path(@item)
    #   end
    # end
  
    private
      def set_itemPrices
        @itemPrice = ItemPrice.find(params[:id])
      end
  
      def itemPrice_params
        params.require(:itemPrice).permit(:category_id, :name, :description, :color, :weight, :inventory_level, :reorder_level, :is_featured, :active)
      end
  
      def user_params      
        params.require(:itemPrice).permit(:category_id, :name, :description, :color, :weight, :inventory_level, :reorder_level, :is_featured, :active)
      end
  
end