require 'spec_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { FactoryGirl.build :rating }
  subject { rating }

  it { should respond_to(:comment_id) }
  it { should respond_to(:rating_type_id) }
  it { should respond_to(:value) }

  it { should validate_presence_of :comment_id }
  it { should validate_presence_of :rating_type_id }
  it { should validate_presence_of :value }

  it { should belong_to :comment }
  it { should belong_to :rating_type }
end
