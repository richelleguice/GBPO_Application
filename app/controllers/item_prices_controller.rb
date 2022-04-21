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
      @item_price = ItemPrice.new(itemPrice_params)
      @item_price.start_date = Date.current
        # @item.user_id = @item.id
        if @item_price.save
          flash[:notice] = "Successfully updated the price."
          redirect_to item_path(@item_price.item) 
        else
          @item = Item.find(params[:item_price][:item_id])
          render action: 'new'
        end      
    end

  
    private
      def itemPrice_params
        params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
      end
  
end