require 'spec_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.build :comment }
  subject { comment }

  it { should respond_to(:body) }
  it { should respond_to(:user_id) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }

  it { should belong_to :user }
end
