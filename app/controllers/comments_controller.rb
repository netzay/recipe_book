class CommentsController < ApplicationController
  def index
    if params[:recipe_id]
      @comments = Recipe.find(params[:recipe_id]).comments
    else
     @comments = Comment.all
    end
  end

  def show
    if params[:recipe_id]
      @comment = Recipe.find(params[:recipe_id]).comments.find(params[:id])
    else
      @comment = Comment.find_by(params[:id])
    end
  end

  def new
    if params[:recipe_id] && !Recipe.exists?(params[:recipe_id])
      redirect_to recipes_path, alert: "Recipe not found."
    else
      @comment = Comment.new(recipe_id: params[:recipe_id])
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to recipe_comment_path(@comment.recipe.id, @comment)
    else
      render :_form_errors
    end
  end


  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to recipe_path(@comment.recipe)
  end

  def edit
    if params[:recipe_id]
      recipe = Recipe.find_by(id: params[:recipe_id])
      if recipe.nil?
        redirect_to recipe_path, alert: "Recipe not found."
      else
        @comment = recipe.comments.find_by(id: params[:id])
        redirect_to recipe_comments_path(recipe), alert: "Recipe not found." if @comment.nil?
      end
    else
      @comment = Comment.find(params[:id])
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy!
    redirect_to recipes_path
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content, :recipe_id)
  end
end
