class RecipesController < ApplicationController

  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :next]
  #find all recipes and current user
  def index
    @recipes = Recipe.all
    @user = current_user
    respond_to do |f|
      f.html
      f.json {render json: @recipes}
    end
  end

  def next
    if @recipe
      @next_recipe = @recipe.next
      render json: @next_recipe
    else
      redirect_to recipes_path
    end
  end

  #search method call from recipe model for search parameter
  def search
    @recipes = Recipe.search(params[:search])
  end

  #find recipe by id and display
  def show
    set_recipe
    respond_to do |f|
      f.html {render :show}
      f.json {render json: @recipe}
    end
  end


  #create new recipe and provide ingredient fields for existing and to create new
  def new
    @recipe = Recipe.new
    @ingredients = 10.times.collect { @recipe.recipe_ingredients.build }
  end

  #create recipe, associate to user, verify fields are complete and add ingredients to recipe before saving and redirect to show page for recipe
  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      @recipe.add_ingredients(recipe_ingredient_params)
      redirect_to recipe_path(@recipe)
    else
      render :new
    end
  end

#find recipe to edit, verify user who created it is trying to edit
  def edit
    @recipe = find_by_id(Recipe)
    if session[:user_id] == @recipe.user_id 
      recipe = 3.times.collect { @recipe.recipe_ingredients.build }
    else
      redirect_to recipes_path, notice: "That is not your recipe to edit!"
    end
  end

  #find recipe, add ingredients in ingredient params
  def update
    recipe = find_by_id(Recipe)
    if recipe.update(recipe_params)
      recipe.add_ingredients(recipe_ingredient_params)
      redirect_to recipe_path(recipe), notice: "Your recipe has successfully been updated"
    else  
      redirect_to new_recipe_path, alert: recipe.errors.full_messages.each {|m| m}.join
    end
  end

  #rediret if not users recipe, otherwise delete
  def destroy
    @recipe = find_by_id(Recipe)
    if session[:user_id] != @recipe.user_id 
      redirect_to recipe_path, alert: "Not your recipe to delete."
    else
      @recipe = find_by_id(Recipe)
      @recipe.destroy!
      redirect_to recipes_path
    end
  end

  #find newest recipe using AR with method in model
  def find_newest
    @recipes = Recipe.newest
    render "recipes/index"
  end

  #find newest recipe using AR with method in model
  def find_quickest
    @recipes = Recipe.quickest 
    render "recipes/index"
  end
  
  #order recipes from least to most ingredients using AR with method in model
  def most_ingredients
    @recipes = Recipe.most_ingredients
    render "recipes/index"
  end


  private

  #find recipe
  def set_recipe
    @recipe = Recipe.find_by_id(params[:id])
  end

  #params for a recipe
  def recipe_params
    params.require(:recipe).permit(:title, :category, :directions, :cook_time, :search)
  end
  
  #params for adding ingredients
  def recipe_ingredient_params
    params.require(:recipe).permit(recipe_ingredients_attributes: [:amount, :ingredient_id, ingredient: [:name]])
  end
end