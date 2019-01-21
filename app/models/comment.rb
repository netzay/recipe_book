class Comment < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :title

	def next
    	@comment = Comment.where("id > ?", id).first
    	if @comment
    		@comment
    	else
    		binding.pry
    	 	Comment.first
  		end
  	end
end