class OrdersController < ApplicationController
    include AppHelpers::Cart
    include AppHelpers::Shipping

    before_action :check_login
    authorize_resource
  
    def index
      if current_user.role?(:customer)
        @all_orders = current_user.customer.orders.all
      else
        @pending_orders = Order.not_shipped.chronological
        @all_orders = Order.all
        @past_orders = @all_orders - @pending_orders
      end
    end
  
    def show
      @order = Order.find(params[:id])
      @previous_orders = @order.customer.orders.chronological.to_a - [@order]
      @order_items =  @order.order_items.alphabetical
    end
  
    def edit
    end
  
    def create
      @order = Order.new(order_params)
      # set date to current date, cal shipping cost (shipping), total cost, saving
      # need to save each item to the order then need to pay (pay from order model), then empty cart
      #redirect to order path, if failure, 
      @order.date = Date.current
      @order.shipping = calculate_cart_shipping
      @order.products_total = calculate_cart_items_cost

      if @order.save
        save_each_item_in_cart(@order)
        @order.pay
        clear_cart
        redirect_to order_path(@order), notice: "Thank you for ordering from GPBO."
      else
        redirect_to :order_checkout
      end
    end
  
    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:customer_id, :address_id, :credit_card_number, :expiration_year, :expiration_month)
    end
  
end