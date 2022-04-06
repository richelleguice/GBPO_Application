class CartController < ApplicationController
    include AppHelpers::Cart
    include AppHelpers::Shipping
    include ApplicationHelper

    before_action :check_login
  
    def show
      @items_in_cart = get_list_of_items_in_cart
      @subtotal = calculate_cart_items_cost
      @shipping_cost = calculate_cart_shipping
      @total = @shipping_cost + @subtotal

    #   redirect_to view_cart_path(@cart)
    end

    def checkout 
        @items_in_cart = get_list_of_items_in_cart
        @subtotal = calculate_cart_items_cost
        @shipping_cost = calculate_cart_shipping
        @total = @shipping_cost + @subtotal
        @addresses = get_address_options(current_user)
        @order = Order.new

    #   redirect_to :checkout
    end
  
    def add_item
        add_item_to_cart(params[:id])
        @item = Item.find(params[:id])
        flash[:notice] = "#{@item.name} was added to cart."
        redirect_back fallback_location: home_path 
    end

    def remove_item
        remove_item_from_cart(params[:id])
        @item = Item.find(params[:id])
        flash[:notice] = "#{@item.name} was removed from cart."
        redirect_to view_cart_path
    end

    def empty_cart
        clear_cart
        flash[:notice] = "Cart is emptied."
        redirect_to view_cart_path
    end
  
end