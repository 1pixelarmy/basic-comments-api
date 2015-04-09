FactoryGirl.define do
  factory :rating do
    comment
    rating_type
    value {rand(0..5)}
  end

end
