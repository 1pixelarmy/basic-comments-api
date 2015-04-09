class CommentFlag < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user

  validates :comment_id, presence: true
  validates :user_id, presence: true
end
