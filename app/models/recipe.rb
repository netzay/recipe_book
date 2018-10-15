class Recipe < ActiveRecord::Base
	belongs_to :user
	has_many :recipe_ingredients
	has_many :ingredients, through: :recipe_ingredients
	validates :title, uniqueness: true
	validates :title, presence: true
	
	accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :recipe_ingredients, reject_if: :all_blank, allow_destroy: true

 scope :created_before, ->(time) { where("created_at < ?", time) }

	def self.valid_entry(params)
		return !params[:recipe][:title].empty? && !params[:recipe][:category].empty? && !params[:recipe][:directions].empty? && !params[:recipe][:cook_time].empty? 

	end	

  def self.newest(total = all.size)
    order("ID DESC").limit(total)
  end

  def self.quickest(total = all.size)
    order("cook_time ASC").limit(total)
  end

  def self.most_ingredients
    @recipes = Recipe.all
    lengths = Hash.new 
    @recipes.each do |recipe|
      lngth = recipe.ingredients.length
      lengths[recipe] = lngth
    end
    most = lengths.sort_by {|k,v| k}
    @recipes = most.recipes
  end


  def self.least_ingredients(number = all.size)

  end

 def self.search(search)
      if !Ingredient.find_by(name: search)
        Recipe.none
      elsif
        ingredient = Ingredient.where("name LIKE ?", search)[0]
        @recipes = ingredient.recipes
      end
    end



  



  def add_ingredients(params)
    
    params[:recipe_ingredients_attributes].each do |k, recipe_ingredient|

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
