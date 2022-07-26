class ItemsController < ApplicationController
    # A callback to set up an @owner object to work with 
    before_action :set_item, only: [:show, :edit, :update, :destroy, :toggle_active, :toggle_feature]
    before_action :check_login, except: [:index, :show]
    authorize_resource
  
    def index
      @categories = Category.all.paginate(page: params[:page]).per_page(10)
      if(params[:category])
        @category = Category.find(params[:category])
        @featured_items = Item.featured.for_category(@category).to_a
        @other_items = Item.for_category(@category).to_a - @featured_items
      else 
        @featured_items = Item.featured.to_a
        @other_items = Item.active.all.to_a - @featured_items
      end
    end
  
    def show
      if logged_in? && (current_user.role?(:admin))
        @prices = @item.item_prices.to_a
      end
      
      @similar_items = Item.for_category(@item.category).active.to_a - [@item]
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
      if @item.destroy
        item = nil
        redirect_to items_url, notice: "Destroyed!"
      else
        redirect_back fallback_location: item_path(@item)
      end
    end

    def toggle_active
        if @item.active?
            # @item.update_attribute(:active, false)
            @item.make_inactive
            flash[:notice] = "#{@item.name} was made inactive"
        else
            @item.make_active
            # @item.update_attribute(:active, true)
            flash[:notice] = "#{@item.name} was made active"
        end
        redirect_back fallback_location: home_path
    end

    def toggle_feature
        if @item.is_featured
            @item.update_attribute(:is_featured, false)
            flash[:notice] = "#{@item.name} is no longer featured"
        else
            @item.update_attribute(:is_featured, true) 
            flash[:notice] = "#{@item.name} is now featured"
        end
        redirect_back fallback_location: home_path
    end
  
    private
      def set_item
        @item = Item.find(params[:id])
      end
  
      def item_params
        params.require(:item).permit(:category_id, :name, :description, :color, :weight, :inventory_level, :reorder_level, :is_featured, :active)
      end
  
end