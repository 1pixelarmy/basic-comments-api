FactoryGirl.define do
  factory :comment do
    user
    body { Faker::Lorem.paragraphs }
  end

end
