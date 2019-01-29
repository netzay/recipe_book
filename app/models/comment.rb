class Comment < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :title

    # def next(recipe_id)
    #   recipe = Recipe.find_by(id: recipe_id)
    #   @comment = Comment.where("id > ?", id).first
    #   if @comment
    #     @comment
    #   else
    #     recipe.comments.first
    #   end
    # end

end