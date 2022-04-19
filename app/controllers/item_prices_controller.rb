class ItemPricesController < ApplicationController
    before_action :check_login
    authorize_resource
  
    def new
      @item_price = ItemPrice.new
      @item = Item.find(params[:item_id])
    end
  
    def edit
    end
  
    def create
      @itemPrice = ItemPrice.new(itemPrice_params)
        # @item.user_id = @item.id
        if @itemPrice.save
          flash[:notice] = "Successfully updated the price."
          redirect_to item_path(@itemPrice.item) 
        else
          render action: 'new'
        end      
    end
  
    def checkout
    end
  
    private
      def itemPrice_params
        params.require(:item_price).permit(:item_id, :price)
      end
  
end