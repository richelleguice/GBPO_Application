class SearchController < ApplicationController
    before_action :check_login
    
    def search
        if params[:query].blank?
            redirect_to search_path
        elsif current_user.role?(:customer)
            @query = params[:query]
            @items = Item.search(@query)
            @total_hits = @items.count
        elsif current_user.role?(:admin)
            @query = params[:query]
            @items = Item.search(@query)
            @customers = Customer.search(@query)
            @total_hits = @items.count
        end
    end
  
end