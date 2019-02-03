class Comment < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :title

	scope :sorted, -> { Comment.order("LOWER(title) ASC") }



  end