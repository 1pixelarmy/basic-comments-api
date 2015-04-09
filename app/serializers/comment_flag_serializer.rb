class CommentFlagSerializer < ActiveModel::Serializer
  attributes :id, :user, :comment, :inappropriate
  #belongs_to :user
  #has_one :user
end
