class ItemPricesController < ApplicationController
    before_action :check_login
    authorize_resource
  
    def new
      @itemPrice = ItemPrice.new
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
        params.require(:item_price).permit(:item_id, :price)
      end
  
end