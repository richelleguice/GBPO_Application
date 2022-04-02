class CategoriesController < ApplicationController
    # A callback to set up an @pet object to work with 
    before_action :set_category, only: [:edit, :update]
    before_action :check_login
    authorize_resource
  
    def index
      # get data on all pets and paginate the output to 10 per page
      @active_categories = Category.active.paginate(page: params[:page]).per_page(10)
      @inactive_categories = Category.inactive.paginate(page: params[:page]).per_page(10)
      
    #   if current_user.role?(:owner)
    #     @active_pets = current_user.owner.pets.active.alphabetical.paginate(page: params[:page]).per_page(10)
    #     @inactive_pets = current_user.owner.pets.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    #   else
    #     @active_pets = Pet.active.alphabetical.paginate(page: params[:page]).per_page(10)
    #     @inactive_pets = Pet.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    #   end
  
    end
  
    # def show
    #   # get the last 10 visits for this pet
    #   @recent_visits = @pet.visits.chronological.last(10).to_a
    # end
  
    def new
      @category = Category.new
    end
  
    def edit
    end
  
    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to categories_path, notice: "Successfully added #{@category.name} to the system."
      else
        render action: 'new'
      end
    end
  
    def update
      if @category.update_attributes(category_params)
        redirect_to categories_path, notice: "Updated #{@category.name}'s information"
      else
        render action: 'edit'
      end
    end
  
    # def destroy
    #   ## Same as owners
    #   if @pet.destroy
    #     # redirect_to pets_path, notice: "Removed #{@pet.name} from the PATS system"
    #   else
    #     @recent_visits = @pet.visits.chronological.last(10).to_a
    #     render action: 'show'
    #   end
    # end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :active)
    end
  
end