class Rating < ActiveRecord::Base
  belongs_to :comment
  belongs_to :rating_type

  validates :comment_id, presence: true
  validates :rating_type_id, presence: true
  validates :value, presence: true
end
