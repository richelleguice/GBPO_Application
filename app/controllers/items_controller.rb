class ItemsController < ApplicationController
    # A callback to set up an @owner object to work with 
    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    def index
      # finding all the active owners and paginating that list (will_paginate)
      @categories = Category.all.paginate(page: params[:page]).per_page(10)
      @featured_items = Item.featured.to_a
      @other_items = Item.all.to_a - @featured_items
    end
  
    def show
      #authorize! :show, @user.role if admin
      # get all the pets for this owner
      @prices = @item.item_prices.to_a
      @similar_items = Item.for_category(@item.category).to_a - (self)
    end
  
    def new
      @item = Item.new
    end
  
    def edit
    end
  
    def create
      @item = Item.new(item_params)
        # @item.user_id = @item.id
        if @item.save
          flash[:notice] = "#{@item.name} was added to the system."
          redirect_to item_path(@item) 
        else
          render action: 'new'
        end      
    end
  
    def update
      respond_to do |format|
        if @item.update_attributes(item_params)
          format.html { redirect_to(@item, :notice => "Successfully updated #{@item.name}.") }
          format.json { respond_with_bip(@item) }
        else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@item) }
        end
      end
    end
  
    def destroy
      ## We don't allow destroy (will deactivate instead)
      if @item.destroy
        # irrelevant now...
        # redirect_to owners_url, notice: "Successfully removed #{@owner.proper_name} from the PATS system."
      else
        # we still want this path with the base error message shown
        # @current_pet = @owner.pets.alphabetical.active.to_a
        render action: 'show'
      end
    end

    def toggleActive
        if self.active?
            self.update_attribute(:active, true)
        else
            self.update_attribute(:active, false)
        end
    end

    def toggleFeature
        if self.featured?
            self.update_attribute(:featured, false)
        else
            self.update_attribute(:featured, true)
        end
    end
  
    private
      def set_item
        @item = Item.find(params[:id])
      end
  
      def item_params
        params.require(:item).permit(:category_id, :name, :description, :color, :weight, :inventory_level, :reorder_level, :is_featured, :active)
      end
  
      def user_params      
        params.require(:item).permit(:category_id, :name, :description, :color, :weight, :inventory_level, :reorder_level, :is_featured, :active)
      end
  
end