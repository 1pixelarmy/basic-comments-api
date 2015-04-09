class Comment < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true

  has_many :ratings, dependent: :destroy
  has_many :comment_flags, dependent: :destroy

  def is_inappropriated?
    if comment_flags.where(:inappropriate => true).size > 4
      return true
    end
    return false
  end
end
