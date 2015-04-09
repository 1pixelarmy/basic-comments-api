FactoryGirl.define do
  factory :comment_flag do
    comment
    user
    inappropriate true
  end

end
