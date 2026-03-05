class Api::CategoriesController < ApplicationController

  # GET /api/categories
  # Returns all categories sorted alphabetically
  def index
    categories = Category.order(:name)
    render json: categories
  end


  # FEATURE-001
  # POST /api/categories
  # Allows users to create a new expense category from the UI
  def create
    category = Category.new(category_params)

    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  # Strong parameters for category creation
  def category_params
    params.require(:category).permit(:name)
  end

end