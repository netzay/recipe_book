class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :next]

  def ajax_new
    render :_ajax_new
  end

  def sort
    @recipe = find_by_id(Recipe)

    @comments = @recipe.comments

     respond_to do |f|
      f.html {render :show}
      f.json {render json: @comments.sorted}
    end
  
  end

  def index
    @recipe = Recipe.find(params[:recipe_id])
    #@comments = Recipe.find(params[:recipe_id]).comments.all
    #@comments = @recipe.comments
    respond_to do |f|
      f.html {render :index}
      f.json {render json: @recipe.comments}
    end
  end

  #find comment based on recipe id
  def show
    @comments = find_by_id(Recipe).comments.all
    @comment = find_by_id(Recipe).comments.find(params[:id])  
    if @comment  
      respond_to do |f|
        f.html {render :index}
        f.json {render json: @comment}
      end
    else
      @comments.sort
      respond_to do |f|
        f.html {render :index}
        f.json {render json: @comments}
      end
    end
  end

  #create a new comment if the recipe id exists and attach it to that recipe id
  def new
      @comment = Comment.new(recipe_id: params[:recipe_id])
      render :_ajax_new, layout: false
  end

  #create a comment and attach it to the current user.
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment
      # redirect_to recipe_path(@comment.recipe.id, @comment)
    else
      render "recipes/show"
    end
  end

  #find the comment by id and update
  def update
    @comment = find_by_id(Comment)
    @comment.update(comment_params)
    redirect_to recipe_path(@comment.recipe)
  end

  #find comment by id and by recipe id, if user who created it wants to edit, allow or prevent and redirect to recipe
  def edit
    @recipe = find_by_id(Recipe)
    @comment = find_by_id(Comment)
    if session[:user_id] != @comment.user_id 
      redirect_to recipe_path, alert: "This is not your comment."
    else
      @comment = find_by_id(Comment)
    end
  end

  #find comment by id, verify user created it before deleting, re-direct and prevent if not
  def destroy
    @recipe = find_by_id(Recipe)
    @comment = find_by_id(Comment)
    if session[:user_id] != @comment.user_id 
      redirect_to recipe_path, alert: "This is not your comment."
    else
      @comment = find_by_id(Comment)
      @comment.destroy!
      redirect_to user_path
    end
  end



  private

  #params for comments
  def comment_params
    params.require(:comment).permit(:user_id, :title, :content, :recipe_id)
  end
  def set_comment
    @comment = Comment.find_by(params[:comment_id])
  end
end