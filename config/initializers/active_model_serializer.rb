# config/initializers/active_model_serializer.rb
ActiveModel::Serializer.setup do |config|
  config.embed = :ids
  config.include = true

  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = false

  # Disable for ArraySerializer
  ActiveModel::ArraySerializer.root = false

end