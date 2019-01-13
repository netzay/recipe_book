class Recipe < ActiveRecord::Base
	belongs_to :user
  has_many :comments
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates :category, presence: true
  validates :directions, presence: true
  validates :title, presence: true
  validates :cook_time, presence: true

  
  
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :recipe_ingredients, reject_if: :all_blank, allow_destroy: true

  scope :quickest, -> { order("cook_time ASC") }
  
  def self.valid_entry(params)
    return !params[:recipe][:title].empty? && !params[:recipe][:category].empty? && !params[:recipe][:directions].empty? && !params[:recipe][:cook_time].empty? 
  end

  def self.newest(total = all.size)
    order("ID DESC").limit(total)
  end

  def self.most_ingredients
    Recipe.select('recipes.*, count(ingredient_id) as ingredients_count').joins(:ingredients).group(:id).order('ingredients_count DESC')
  end
  

  def self.search(search)
    if !Ingredient.find_by(name: search)
      Recipe.none
    else
      ingredient = Ingredient.where("name LIKE ?", search)[0]
      @recipes = ingredient.recipes     
    end
  end

  def next
    recipe = Recipe.where("id > ?", id).first
    recipe ? recipe : Recipe.first
  end

  #deletes ingredients to avoid duplicating entire recipe when editing
  def delete_ingredients
      ingredients.size.times do
      ingredient = RecipeIngredient.find_by(recipe_id: self.id)
      ingredient.delete
    end
  end

  def add_ingredients(params)

    delete_ingredients
    
    params[:recipe_ingredients_attributes].each do |i, recipe_ingredient|

      if !recipe_ingredient[:ingredient][:name].empty?
        ingredient_name = recipe_ingredient[:ingredient][:name].downcase
        ingredient = Ingredient.find_or_create_by(name: ingredient_name)
      elsif !recipe_ingredient[:ingredient_id].empty?
        ingredient = Ingredient.find_by(id: recipe_ingredient[:ingredient_id])
      end

      if !recipe_ingredient[:amount].empty?
        RecipeIngredient.create(amount: recipe_ingredient[:amount], ingredient_id: ingredient.id, recipe_id: self.id )
      end
    end
  end
end
