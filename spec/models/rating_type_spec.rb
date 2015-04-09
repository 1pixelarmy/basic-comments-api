require 'spec_helper'

RSpec.describe RatingType, type: :model do
  let(:rating_type) { FactoryGirl.build :rating_type }
  subject { rating_type }

  it { should respond_to(:name) }
end
