class RatingSerializer < ActiveModel::Serializer
  attributes :id, :comment, :value, :rating_type
  #belongs_to :user
  #has_one :user
end
